| Prev | Home | Next |
|---|---|---|
| [[Resume-STAR]] | [[Home]] | [[Terraform]] |

# SRE Realtime Quick Notes

real time SRE interview questions

## Incident vs Problem
- Incident: Unplanned interruption or reduction in service quality.
- Problem: Underlying cause of one or more incidents.

## Acronyms
- CDR
- ID Proofing (Biometrics) — Talk to Basappa

## Case Study: Address Field Not Loading
### What Went Wrong
- Address field failed when users navigated back to previous page.
- QAS (Quick Address Search) backend failure.
- Node.js logic bug prevented component reload after navigation.

### What is QAS?
- Address validation and autocomplete engine.
- If QAS fails, fields do not populate/validate.

### How We Identified the Issue
- Splunk error reports showed repeated QAS lookup failures.
- Impact small (10–15 customers out of ~1000).
- Matched known pattern: PO Box–only addresses rejected.

### What Was the Fix
- Backend remediation: Node.js fix to handle QAS response and reload field.
- Customer contact team did manual remediation until release.
- Included in weekly remediation deployment.

### Why It Reached Production (Gap)
- Back-navigation reload not covered in QA.
- QAS failure scenarios (e.g., PO Box–only) not tested in lower envs.
- UAT integration tests missed negative/edge patterns.

## Operational Activities
- Certificate renewal (proactive monitoring and rotation)
- Patching: Minor (automated), Major (coordinated)
- App & DB restoration
- Disaster Recovery drills and runbooks
- Annual capacity planning: baseline perf, forecast growth, plan scale
- Currency upgrades (frameworks/platform components, e.g., NEF/NABServ)
- Compliance: tagging, security reviews, audits
- Operational Readiness (PRR: SDM, SO, DR, Security, ITSC evidence)
- SDM reviews: TSR, performance, dashboards, architecture updates
- SO reviews: third-party agreements, CHF dashboards, txn/response changes
- Security (SCA): TLS, encryption, IAM, alerting/logging/audit
- Code reviews, change creation & approvals (CAB)
- Tracking SCA controls across assets (certs, encryption, backups, ITSM, logging, KMS, S3)

## Tooling
- xMatters: incident automation, runbooks, multichannel alerting, ITSM integration

## Recovery Objectives
- RTO — time to restore service
- RPO — acceptable data loss

## Context Example
- ECS to EKS migration for compliance, unified Helm deployments, automation, observability, isolation, and portability.

## Severity
- Sev1: Stop everything — business down, high impact
- Sev2: Fix fast — degraded, partial impact

