| Prev | Home | Next |
|---|---|---|
| [[Intro-HR-Questions]] | [[Home]] | [[Linux-Interview]] |

# Kubernetes Quick Notes

## Table of Contents
- Core Components
- Probes
- Labels & Selectors
- Deployments & Services
- Ingress & Gateway API
- Traffic Flow (AWS EKS)
- Storage (PV/PVC/StorageClass)
- RBAC
- ConfigMaps & Secrets
- Namespaces & Resource Management
- Helm
- Troubleshooting
- Logging
- Docker

## Core Components
### Master Node
- **API Server**: central control plane, all components communicate through Kubernetes API.
- **Scheduler**: assigns pods to nodes based on resource availability and scheduling constraints.
- **Controller Manager**: cluster automation (replication, node lifecycle, endpoint management).
- **etcd**: cluster state storage (distributed key-value store).

### Worker Node
- **Kubelet**: ensures containers are running and reports status.
- **Kube-proxy**: networking rules and pod-to-pod load balancing.
- **Container runtime**: e.g., Docker, Podman, containerd.

## Useful kubectl commands
```bash
kubectl run my-pod --image=nginx:alpine
kubectl get nodes
kubectl describe pods <POD_NAME>
kubectl logs <pod_name>
kubectl get po -A | grep scheduler
```

## Probes
- **Liveness Probe**: restarts unhealthy containers.
- **Readiness Probe**: marks pod ready to receive traffic.
- **Startup Probe**: for slow-starting containers, prevents liveness before startup.

## Labels & Selectors
- Labels are key-value pairs.
- Selectors match resources by labels.
- Service traffic and deployment selection depend on matching selectors.

## Deployments & Services
- **Deployment** defines desired state for Pods/ReplicaSets.
- Kubernetes ensures actual state matches desired.

### Service Types
| Type | Description |
|---|---|
| ClusterIP | Internal cluster access, default |
| NodePort | Exposes via `<NodeIP>:NodePort` |
| LoadBalancer | External cloud LB |

### Ingress
- Layer 7 routing (host/path, TLS).
- Requires Ingress Controller.

## Ingress & Gateway API
- **Ingress** resource defines HTTP/S routing.
- **Ingress Controller** (NGINX, HAProxy, Istio) implements rules.
- **Gateway API** is modern alternative (Gateway, HTTPRoute).

## Service Mesh (Istio)
- mTLS, traffic shaping, observability, sidecar proxies.
- Resources: Gateway, VirtualService, DestinationRule.

## Traffic Flow (AWS EKS example)
Client → DNS (Route53) → NLB → Ingress Controller → Ingress rules → ClusterIP Service → Pod → sidecar → App

## Storage (PV/PVC/StorageClass)
- **emptyDir**: ephemeral, pod life.
- **hostPath**: mounts host dir.
- **PV**: cluster storage (EBS, NFS, iSCSI).
- **PVC**: claim by pod.
- **StorageClass**: dynamic PV provisioning.

## RBAC
- **Role**, **ClusterRole**.
- **RoleBinding**, **ClusterRoleBinding**.
- IRSA (IAM Roles for Service Accounts) for AWS.

## ConfigMaps & Secrets
- ConfigMap: non-sensitive config.
- Secret: sensitive, base64-encoded.

## Namespaces & Resource Management
- Namespaces isolate resources.
- ResourceQuotas limit usage.
- Requests and limits for pods (CPU/Memory).

## Helm
Chart layout:
- Chart.yaml
- values.yaml
- templates/
- charts/

Commands:
```bash
helm install my-app ./chart
helm upgrade --install my-app ./chart -f values-dev.yaml --set image.tag=v2
helm template my-app ./chart
```

## Troubleshooting
- **CrashLoopBackOff**: bad config, missing secrets, init failure, PV issue.
- **Intermittent traffic**: check ingress, service endpoints, readiness, logs.
- **Restarts**: OOMKilled, CPU throttling, probes.
- **Not scheduling**: nodes, resources, taints, selectors, PVC, IP.

## Logging
- Node-level daemonset (Fluent Bit, Splunk) collects `/var/log/containers`.

## Docker
Commands
- `docker ps`, `docker run -d`, `docker logs`, `docker exec`

