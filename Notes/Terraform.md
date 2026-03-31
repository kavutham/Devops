# Terraform Quick Notes


## Terraform



## New version: 1.14



## provider.tf = how Terraform talks to AWS

## main.tf = what Terraform builds

## variables.tf = what Terraform needs

## outputs.tf = what Terraform returns

## locals.tf = reusable logic

## data.tf = read existing AWS resources

## backend.tf = where state live

## versions.tf = version locking



Refer **Variable** using var.variablename



**Locals**: Similarly to variables they serve as placeholders for data and values. Differently from variables, users can't override them by passing different values.

Refer locals using local.x



**Output variabl**e: It allow you to display/print certain piece of data as part of Terraform execution.



**data sources**: Data sources used to get data from providers or in general from external resources to Terraform (e.g. public clouds like AWS, GCP, Azure).

data "aws\_vpc" "default {

&#x20; default = true

}

**Provisioners**: It can be described as plugin to use with Terraform, usually focusing on the aspect of service configuration and make it operational.

**local-exec** provisioners run commands on the machine where Terraform is executed, while remote-exec provisioners run commands on the remote resource.



**what is alias:?** Alias helps to choose between different account of same provider. One provider block holds only one region, one account. Refer the resource creation block using the alias provider.



**depends\_on:** create dependency for resources, wait for one resource to be created before the dependent creates, like first create the IAM role and then the RDS.

Implicit dependencies only work when Terraform sees a direct reference like iam role referred in iam policy resource by any logic or reference.

When resources depend on side effects like IAM propagation, Terraform gets it wrong. In those cases, I use explicit depends\_on to enforce ordering.



Migrate state from local to remote: terraform init -migrate-state

terraform apply - create state file

terraform show - inspect current state

terraform state list - list the resources in state

terraform state mv - rename an existing resource

tflint, tfvalidate, terraform plan



terraform import is a CLI command used for importing an existing infrastructure into Terraform's state



## how to prevent delete? Protection

Create resource before destroy. (Terraform always first destroy and then create. For Scenarios like destroying resource first can cause downtime, disruption, service outages) (bucket name must exist before switch dependencies, new cert first before deleting old one to avoid connection, create launch template before it destroys as ASG depends on it)

lifecycle {

&#x20; create\_before\_destroy = true

}

Prevent Deletion of resource

lifecycle {

&#x20;   prevent\_destroy = true

&#x20; }



## AWS Authenticaion:

**Local** - Use AWS CLI, with profiles stored in .aws/crednetials, or environment variable, secret ID, Secret Key, or existing assumerole using STS, or AWS SSO.

**GitHub Action**s:In GitHub Actions, I use OIDC. GitHub issues a shortlived identity token, AWS STS validates it, and Terraform assumes an IAM role. The role has a trust policy that allows only my repo and branch to assume it, and a permissions policy that defines what Terraform can do. This avoids storing any access keys.



## Remote Configuration:

instead of backend s3, we use backend as remote with {hostname, organization \& workspace} in terraform.tf

## S3

backend "s3" {

&#x20; bucket = "my-tf-state"

&#x20; key    = "prod/vpc/terraform.tfstate"

&#x20; region = "ap-southeast-2"

&#x20; dynamodb\_table = "tf-locks"

}

## Remote:
terraform {

&#x20; backend "remote" {

&#x20;   hostname     = "app.terraform.io"

&#x20;   organization = "my-org"



&#x20;   workspaces {

&#x20;     name = "prod-vpc"

&#x20;   }

&#x20; }

}



## Why we migrate from TFE to Harness: (TFE uses one workspace to store one statefile to avoid conflicts between environment, so each environment has its own workspace)

## **Cost:** license cost Per user cost, many engineer run it occasionally.
## Require additional dedicated infra, manage vm, patching, upgrades, backups etc. Admin overhead to manage workspace \& policies.



Harness is uses built-in remote, automatic encryption, automatic locking etc.



Harness runs Terraform through a delegate or cloud runner, and it manages the entire lifecycle " init, plan, apply, logs, and even remote state if needed.

For AWS authentication, Harness uses an AWS Connector. The connector can authenticate using IAM roles, access keys, or OIDC. The IAM role has a trust policy that allows the Harness delegate or OIDC provider to assume it, and a permissions policy that defines what Terraform can manage. Terraform simply uses the temporary credentials provided by Harness and runs normally.



## Secrets stored in state file?

Marking a variable as sensitive does not prevent it from being stored in the state file. It only hides it from logs.

To prevent secrets from being stored, we avoid passing secrets as variables and instead fetch them dynamically using **data** sources from Vault or AWS Secrets Manager



**templatefile function** - templatefile() loads an external script/template file and injects variables into it, instead of writing long inline code inside Terraform. TO run ec2- user data , shell script, kube manifests.

templatefile("${path.module}/script.sh.tpl", {

&#x20; name = var.name

&#x20; env  = var.environment

})



## Rapid Questions



## Real scenario where terraform plan shows no change, but apply still modifies resources

**Ans**: When providers return computed values only during apply (e.g., AWS default values, IAM policies, tags, RDS params).

Plan cannot detect drift, but apply forces reconciliation



## How do you detect and fix infra drift without downtime?

Drift = cloud resources changed outside Terraform.Detect using terraform plan or platform drift detection (TFE/Harness).

Fix by reapplying Terraform (that may destroy and create resources) or importing missing resources.



## How to prevent provider mismatch issues in production?

Provider version mismatches break production because provider schemas change (example different version of aws provider on s3 resource might different things changes like ACL not default, or removed completely. Terraform sees the resource as different and forces replacement. I prevent this by locking provider versions, reviewing upgrade guides, and testing upgrades in isolated environments.



## Terraform plan looks safe but causes an outage. How?

Plan is a prediction. Apply is the truth. Providerside changes can cause outages even when plan looks safe.

Common outages: Provider version change, implicit dependencies wrong order, aws force replacement for (IAM policy, ALB listners RDS Params etc)



## Drift is detected in production. Roll back or adopt " how do you decide?

Rollback when drfit accident, breaks compliance, introduce risk

Adopt when drift intentional, requires new state change, or business requires new changes



## How do you refactor Terraform modules used by multiple teams safely?

Use versioned modules, backwardcompatible changes, and statesafe refactoring using terraform state mv and rm.



## Difference between provisioners and templatefile?

Tempaltefile: Renders an external script/template into a string; it does NOT execute anything. Used for user\_data, cloudinit, config files, IAM policies, etc

Provisioners: Actually executes commands or scripts (local or remote) during apply. Used only when you must run commands on a machine or after resource creation. Example (Install soft in ec2, bootstrap a vm, run configuration scripts)



## Ignore the drfit to no changes?

## Ans:
Create once, then Terraform must forget it - terraform state rm + remove from code

Delete a particular resource only - Remove it only from the resource from tf file, ignore the state file

Keep in terraform but ignore changes - lifecycle {ignore\_changes = \[]}

Protect from deletion - lifecycle {prevent\_destroy = true}

stop terraform from managing only some attributes - ignore\_changes

No deletion No recreation - terraform state mv old\_resource new\_resource + update the code too with correct name



## Terraform Migration Checklist:

## Lock the provider version
## Read provider upgrade guides
## Upgrade terraform CLI gradually one version at a time minor to upgrade
- 4. terraform init-upgrade --> refresh provider plugin, bring in module latest changes and version.
## Validate plan output -Look for forced replacement, replace deprecated fields,
## Nonprod first - dev, stage and prod, Validate drift
- 7. Use terraform state mv -> rename resources to avoid recreation by destroy first.
## Rerun plan until clean and merge only after stable.





## Scenarios:

## SFTP Old version after 2 years, tried to adopt during production to recreate it
## Issues with addressing and deploying wrong state in incorrect workspace with different configs.
## Dependency issues and depends on has version mismatch ?? Not supported??
## Managint state file from local using terraform login, push and pull state file after fixing it. Refactor it.
## Module version mismatch to create wrong resource and drift. only module version has issues. SO always use terraform init-upgrade.
## We hit a performance bottleneck on our RDS Postgres instance due to storage and IOPS saturation. Increasing IOPS was an online change, but moving to a higherperformance storage class required a brief reboot, so I planned a controlled Terraform apply during a maintenance window. The upgrade completed with minimal downtime and restored stable performance.
## **Situation**:
We noticed our RDS Postgres instance suddenly consuming storage at an abnormal rate, and performance started degrading. CloudWatch metrics showed continuous storage growth even though application traffic was normal.
**Task**:
My responsibility was to identify the root cause quickly and stabilise the database before it hit a storagefull condition.
**Action**:
I analysed CloudWatch metrics and RDS logs and found that an old logical replication slot was left active after a client disconnected, causing WAL files to accumulate. I validated the slot status using PostgreSQL views and confirmed it was no longer needed. I safely dropped the replication slot and monitored WAL generation and storage usage.
**Result**:
Storage usage immediately stabilised, WAL retention returned to normal, and database performance recovered without requiring downtime. This prevented a potential outage and avoided unnecessary storage scaling.

A **replication slot** in PostgreSQL is a mechanism that ensures WAL files are retained until a replica or logical consumer has processed them.
If the consumer stops reading, WAL files keep accumulating
**WAL** = WriteAhead Log.
It records every change made to the database.
Used for crash recovery, replication, pointintime recovery, and logical decoding.



