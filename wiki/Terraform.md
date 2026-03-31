| Prev | Home | Next |
|---|---|---|
| [[SRE-Realtime]] | [[Home]] |  |

# Terraform Quick Notes

## Terraform

## New version: 1.14

## Files overview
- **provider.tf** = how Terraform talks to AWS
- **main.tf** = what Terraform builds
- **variables.tf** = what Terraform needs
- **outputs.tf** = what Terraform returns
- **locals.tf** = reusable logic
- **data.tf** = read existing AWS resources
- **backend.tf** = where state lives
- **versions.tf** = version locking

Refer **Variable** using `var.<name>`

**Locals**: Similar to variables but cannot be overridden by users.
Refer locals using `local.<name>`

**Output variable**: Display specific data after apply.

**Data sources**: Read from providers/external resources to use in config.
```hcl
data "aws_vpc" "default" {
  default = true
}
```

**Provisioners**: Plugins to run commands during apply.
- `local-exec` runs on the machine where Terraform executes
- `remote-exec` runs on the remote resource

**alias**: Choose between different accounts/regions of same provider. One provider block = one region/account.

**depends_on**: Create explicit dependency when implicit references are missing or side-effects exist (e.g., IAM propagation).

### State and CLI
```bash
terraform init -migrate-state
terraform apply
terraform show
terraform state list
terraform state mv
tflint && terraform validate && terraform plan
terraform import
```

## Prevent delete / ensure order (lifecycle)
```hcl
resource "example" "r" {
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
  }
}
```

## AWS Authentication
- **Local**: AWS CLI profiles (`~/.aws/credentials`), env vars, STS AssumeRole, AWS SSO.
- **GitHub Actions**: Use **OIDC** with AWS STS to assume IAM role (no long-lived keys).

## Remote Configuration
S3 backend:
```hcl
backend "s3" {
  bucket         = "my-tf-state"
  key            = "prod/vpc/terraform.tfstate"
  region         = "ap-southeast-2"
  dynamodb_table = "tf-locks"
}
```

Terraform Cloud/Enterprise remote:
```hcl
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "my-org"

    workspaces {
      name = "prod-vpc"
    }
  }
}
```

## Why migrate from TFE to Harness
- **Cost:** Per-user license; infra ops overhead.
- Harness uses built-in remote, encryption, locking, and runs via delegate/cloud runner.
- For AWS auth, Harness uses an AWS Connector (IAM roles, keys, or OIDC).

## Secrets stored in state file?
Marking a variable as sensitive hides it from logs but it may still be in state. Prefer fetching secrets dynamically via data sources (Vault, AWS Secrets Manager).

**templatefile** function:
```hcl
templatefile("${path.module}/script.sh.tpl", {
  name = var.name
  env  = var.environment
})
```

## Rapid Questions
- Plan may miss computed values; apply reconciles actual state.
- Detect drift via plan or platform; fix by apply or import.
- Prevent provider mismatch by version locking and testing upgrades.
- Outages from provider changes, wrong ordering, forced replacements.
- Drift response: rollback vs adopt based on intent/risk.
- Safe refactors with versioned modules and `terraform state mv/rm`.
- `templatefile` vs provisioners: render vs execute.
- Ignore drift: `lifecycle { ignore_changes = [...] }`, or remove from state.

## Terraform Migration Checklist
- Lock provider versions
- Read upgrade guides
- Upgrade CLI gradually
- `terraform init -upgrade`
- Validate plan output (look for replacements/deprecations)
- Promote non-prod → prod
- Use `terraform state mv` to rename without destroy
- Iterate until plan is clean

## Scenarios
- SFTP component very old; attempted adoption during production triggered recreation
- Wrong workspace/config used; applied to incorrect environment
- Dependency issues; `depends_on` mismatch or not supported across versions
- Managing state locally via `terraform login`, push/pull to repair and refactor
- Module version mismatch created wrong resources and drift; always run `terraform init -upgrade`

## Postgres WAL/Replication Slot Incident (Real-world)
We hit a performance bottleneck on our RDS Postgres instance due to storage and IOPS saturation. Increasing IOPS was an online change, but moving to a higher-performance storage class required a brief reboot, so we planned a controlled Terraform apply during a maintenance window. The upgrade completed with minimal downtime and restored stable performance.

### Situation
We noticed our RDS Postgres instance suddenly consuming storage at an abnormal rate, and performance started degrading. CloudWatch metrics showed continuous storage growth even though application traffic was normal.

### Task
Identify root cause quickly and stabilise the database before it hit a storage-full condition.

### Action
Analysed CloudWatch metrics and RDS logs and found that an old logical replication slot was left active after a client disconnected, causing WAL files to accumulate. Validated the slot status using PostgreSQL views and confirmed it was no longer needed. Safely dropped the replication slot and monitored WAL generation and storage usage.

### Result
Storage usage immediately stabilised, WAL retention returned to normal, and database performance recovered without requiring downtime. This prevented a potential outage and avoided unnecessary storage scaling.

Notes:
- A replication slot ensures WAL files are retained until a consumer processes them.
- If the consumer stops reading, WAL files accumulate.
- WAL = Write-Ahead Log used for crash recovery, replication, PITR, and logical decoding.

