| Prev | Home | Next |
|---|---|---|
| [[Linux-Interview]] | [[Home]] | [[SRE-Realtime]] |

# Resume STAR Quick Notes

## Kubernetes:

We migrated from ECS to EKS as part of NAB’s NEF 2.0 initiative to standardize deployments across the platform, improve scalability and observability, and enable advanced capabilities like service mesh and multi-cloud readiness, which were limited in ECS.

**Certificates**:

Each service required TLS certificates, which we managed either via Kubernetes secrets or integrated certificate management workflows, ensuring proper mounting into pods and alignment with ingress/mTLS requirements.

Mounted as Secrets into pods

Used for: HTTPS (Ingress) & mTLS (sidecars / HAProxy)

**Rotations handled via:** We used Venafi for centralized certificate lifecycle management. Private keys were securely stored in HashiCorp Vault, while certificates were packaged during the Docker build process and retrieved from Artifactory at runtime.

We avoided hardcoding secrets by integrating Vault with Kubernetes ServiceAccounts, ensuring secure, dynamic secret retrieval at runtime.

Mapped ServiceAccount → Vault role & Vault IAM role policies (which secrets Like namespace & path allowed). Vault Sidecar will perform authentication and retrieval.

Path to secrets are added a configmap to kube deployments.

Implemented rolling and canary deployments with proper readiness/startup probes to ensure zero-downtime releases.

## Failure Scenarios:

During early migration, a misconfigured readiness probe combined with incorrect ingress routing caused a production service to become unavailable despite pods being healthy.

## Result:

Standardized deployments across environments, enabling faster and consistent releases with zero downtime. This reduced operational overhead, allowing teams to focus primarily on application development rather than infrastructure and deployment configurations. Common concerns like networking, IAM, and deployment patterns were already handled within the framework, and only required changes when introducing new dependencies such as S3 integrations, policy updates, or external APIs.

## Complexity:

The main complexity wasn’t just migration — it was standardizing diverse microservices with different dependencies into a consistent, secure, and scalable Kubernetes deployment model while handling real-world production issues.

## RDS Migration

At NAB, we needed to migrate a production PostgreSQL RDS database across AWS accounts as part of a security and environment isolation initiative and to put all related service into single account and remove cross account dependency and account management.

The database supported critical services, so data integrity and minimal downtime were non-negotiable. Also focus on no loss of users, roles and permission. Minimal application change and consistent performance.

## Other Migration Options:

- 1. pg_dump → Slow for large DB with GB. Requires export → transfer → Import and high downtime. Risk of missing roles.
- 2. Snapshot → Preserves roles, schemas, functions. Faster block-level copy, minimal manual effort.
- 3. Database Migration Service → not allowed in NAB due to restrictions. Setup complexity, needs replication instance.
- 4. S3 Import / Export → too much manual effort

## Action

We used **cross-account RDS snapshot migration with KMS key sharing** to securely move the database. Snapshot approach was chosen over pg_dump because it’s faster, consistent, and reduces downtime.  
We took an encrypted snapshot in the source account, updated the KMS key policy to allow the target account to decrypt it, and shared the snapshot. In the target account, we copied the snapshot and re-encrypted it using a local KMS key. Terraform was then used to restore the RDS instance using the `snapshot_identifier` and the target KMS key. Since snapshots preserve users and roles, applications only required endpoint changes.

Since snapshot is a full physical copy:
- All DB users, roles, schemas, and permissions were preserved
- No need for recreation (unlike pg_dump)

## Used Terraform module to provision RDS:

- `snapshot_identifier` → restore from snapshot
- `kms_key_id` → target account key

## Ensured configuration parity:

- Same instance class
- Storage size
- DB parameter groups
- Option groups
- Networking (subnets, security groups)

## Terraform feature flags:
Keep both the KMS and RDS resources in same git but run only when required using feature flag.
```hcl
variable "create_rds" {
  default = false
}

resource "aws_db_instance" "rds" {
  count = var.create_rds ? 1 : 0
  # ...
}
```

## Reduced downtime:
Scheduled a controlled cutover window (~2.5 hrs). Stopped writes during final snapshot to ensure consistency.

## Post-migration optimization:
Application cutover using updated service configuration points to new RDS endpoint with no credentials rotated. Provisioned read replicas using Terraform. Routed read-heavy workloads to replicas to reduce load on primary.

## Validation:
Performed data integrity checks (row counts, roles & permission, critical queries). Verified application connectivity and performance post-cutover using CloudWatch metrics. Compared the data from previous and after migration.

## Rollback:
Rollback was straightforward because the source database remained untouched. If issues occurred after cutover, we simply reverted the application endpoint back to the source RDS and resumed writes. The target instance could then be safely discarded. Since snapshot-based migration is non-destructive, rollback didn’t involve any data recovery complexity.

