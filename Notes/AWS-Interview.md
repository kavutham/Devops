# AWS Interview Quick Notes

## Networking (VPC)
- **Security Group**: instance-level, stateful (response allowed automatically).
- **NACL**: subnet-level, stateless (in/out explained explicitly).
- SG = allow rules only. NACL = allow + deny rules.
- IGW allows direct internet access; NAT Gateway for private outbound.
- One subnet per route table association; one VPC per IGW.

## Load Balancers
- **ALB**: Layer 7, HTTP/HTTPS, host/path routing, WebSockets, WAF.
- **NLB**: Layer 4, TCP/UDP, high performance, static IP.
- ALB uses cross-zone LB; NLB has cross-zone disabled by default.
- ALB for HTTP app traffic, NLB for non-HTTP/low-latency.

## DNS
- Use Alias record for ALB apex domain.
- Use CNAME for subdomains and external domains.
- A record points directly to IP addresses.

## Storage
- Use EBS for single-instance block storage.
- Use EFS for shared files across multiple instances.

## Security
- **AWS Trusted Advisor** checks high utilization (>80% limits).
- **AWS Shield** DDoS protection.
- **Amazon Inspector** security assessment.
- **Amazon Cognito** user auth + authz.
- OIDC for apps/APIs; SAML for enterprise SSO.

## Troubleshooting
- **ALB intermittent 502**: check target health, app port, SG/target group.
- **Slow app, CPU/memory normal**: DB latency, downstream calls, network delays.

## High availability pattern
- Route53 + CloudFront + ALB (multi-AZ) + ASG + RDS (multi-AZ).

## RDS scaling
1. Read replicas for reads.
2. Query optimization (indexes).
3. Scale vertically or tune storage IOPS.

## RDS concepts
- Multi-AZ: synchronous, auto failover.
- Read replica: async, read scaling, no auto failover by default.

## S3 hardening
- Block public access.
- Bucket policies + IAM.
- Avoid ACLs.
