# DevOps-Prep Quick Notes

## Navigation
- [Terraform](terraform.md)
- [Kubernetes](kubernetes.md)
- [Linux](linux.md)
- [AWS](aws.md)

## How to use
1. Browse each file as a topic sheet.
2. Use headings for quick jump links in GitHub.
3. For wiki style navigation, copy these into the GitHub Wiki Pages UI.

---

> Existing detailed Kubernetes notes are moved to `kubernetes.md`.

Master Node Components
API Server
Central control-plane component.
All cluster components communicate through it using the Kubernetes API.
Scheduler
Assigns pods to nodes based on resource availability and scheduling rules.
Controller Manager
Handles cluster automation such as:
- Replication
- Node lifecycle
- Endpoint management
etcd
Distributed key-value store holding the entire cluster state.

Worker Node Components
Kubelet
Node agent ensuring containers are running and reporting status to the control plane.
Kube-proxy
Manages networking rules and load-balances traffic between pods.
Container Runtime
Runs containers inside pods.
Examples: Docker, Podman, containerd.

Useful kubectl Commands
kubectl run my-pod --image=nginx:alpine
kubectl get nodes
kubectl describe pods <POD_NAME>
kubectl logs pod_name
kubectl get po -A | grep scheduler



2. Probes
Liveness Probe
Detects when a container is stuck or unhealthy.
If it fails → Kubernetes restarts the container.
Readiness Probe
Indicates when a container is ready to receive traffic.
Prevents routing to unready pods.
Startup Probe
Used for slow-starting containers.
Prevents liveness probe from killing the pod during startup.
StartupProbe overrides LivenessProbe.

3. Labels & Selectors
Labels
Key-value pairs attached to Kubernetes objects.
Used for grouping, filtering, and identifying resources.
Selectors
Match resources based on labels.
Examples:
- Services use selectors to route traffic
- Deployments use selectors to manage pods
If labels and selectors don’t match → service won’t send traffic.

4. Deployments & Services
Deployment
Declarative definition of desired state for:
- Pods
- ReplicaSets
Kubernetes ensures actual state matches desired state.

Service Types
ClusterIP (default)
- Internal-only access
- Stable virtual IP
- Used for service-to-service communication
NodePort
- Exposes service on <NodeIP>:NodePort
- Opens port on every node
LoadBalancer
- Creates cloud load balancer
- Routes external traffic into cluster
Ingress
- L7 HTTP/HTTPS routing
- Routes based on host/path rules
- Reduces need for multiple load balancers

Service Endpoints
Represent:
- Pod IPs
- Target ports
They act as the backend list for a Service.

5. Ingress & Gateway API
Ingress
Defines routing rules for external HTTP/HTTPS traffic into the cluster.
Notes:
- Ingress is not a pod or service
- Requires an Ingress Controller

Ingress Controller
Actual component that processes traffic.
Examples:
- NGINX
- HAProxy
- Istio Gateway
Responsibilities:
- Watches Ingress resources
- Applies routing rules
- Handles TLS termination
- Forwards traffic to ClusterIP services

Gateway API
Modern replacement for the Ingress resource.
Benefits:
- Better separation between infra and app teams
- More expressive routing
- Standardized across vendors
Resources:
- Gateway
- HTTPRoute

Istio (Service Mesh)
Provides:
- mTLS
- Traffic shaping
- Observability
- Sidecar proxies (Envoy)
Resources:
- Gateway
- VirtualService
- DestinationRule
Traffic:
- North–South → Ingress Gateway
- East–West → Envoy sidecars

6. Traffic Flow (AWS EKS Example)
Client (api.bank.com)
        ↓
DNS (Route53)
        ↓
AWS NLB (pre-created)
  - Target group = worker nodes
  - NodePort (e.g., 8080) where Ingress Controller listens
        ↓
Ingress Controller (NGINX / HAProxy / Istio Gateway)
        ↓
Ingress Rules (host/path routing)
        ↓
ClusterIP Service
        ↓
Pod
        ↓
HAProxy Sidecar (mTLS)
        ↓
Application Container


Enterprise setups:
- NLB stays unchanged
- New services only need:
- ClusterIP service
- Ingress rule update

7. Storage (PV, PVC, StorageClass)
Volume Types
emptyDir
- Created when pod starts
- Deleted when pod stops
hostPath
- Mounts host directory into pod
- Used for accessing host-level paths

Persistent Storage
Persistent Volume (PV)
Cluster-level storage resource (EBS, NFS, iSCSI).
Persistent Volume Claim (PVC)
Pod’s request for storage.
StorageClass
Automates dynamic PV provisioning.
Flow
Pod → PVC → StorageClass → PV → AWS EBS


Use Cases
- Logs
- Caching
- Shared files
- Batch jobs

8. RBAC
Role
Namespace-scoped permissions.
ClusterRole
Cluster-wide permissions.
RoleBinding
Assigns Role to user/group/service account.
ClusterRoleBinding
Assigns ClusterRole cluster-wide.
Access Flow
Role → RoleBinding → ServiceAccount → Pod


IRSA (AWS)
IAM Roles for Service Accounts provide cloud permissions.

9. ConfigMaps & Secrets
ConfigMap
Stores non-sensitive configuration.
Secret
Stores sensitive data (passwords, tokens).
Base64-encoded.

10. Namespaces & Resource Management
Namespaces
- Logical grouping
- Isolation
- Deleting namespace deletes all resources inside
PV is not namespaced.

Resource Quotas
Limit total resource usage per namespace.

Requests & Limits
Requests
Minimum guaranteed CPU/Memory.
Limits
Maximum allowed CPU/Memory.
CPU > limit → throttling
Memory > limit → OOMKill

11. Helm
Chart Structure
Chart.yaml
values.yaml
templates/
  deployment.yaml
  service.yaml
  ingress.yaml
charts/


Commands
helm install my-app
helm upgrade --install my-app ./chart -f values-dev.yaml --set image.tag=v2
helm template my-app ./chart



12. Troubleshooting
CrashLoopBackOff
Causes:
- Wrong config
- Missing secrets
- Init container failure
- PV issues

Traffic Failing Intermittently
Check:
- Ingress
- Service endpoints
- Readiness probe
- Pod logs
- Sidecar/TLS layer

Pod Restarting
Possible:
- OOMKilled
- CPU throttling
- Liveness probe failures
- Dependency failures

Pod Not Scheduling
Check:
- kubectl describe pod
- Node resources
- Node selectors
- Taints/tolerations
- PVC binding
- IP exhaustion (AWS VPC CNI)

13. Logging
Node-level logging via DaemonSet (Fluent Bit, Splunk Forwarder).
Logs collected from:
/var/log/containers



14. Docker
Containers
|  |  | 
|  |  | 
|  |  | 
|  |  | 
|  |  | 
|  |  | 



Images
|  |  | 
|  |  | 
|  |  | 
|  |  | 
|  |  | 



Logs & Debugging
|  |  | 
|  |  | 
|  |  | 
|  |  | 
|  |  | 



Networking
|  |  | 
|  |  | 
|  |  | 
|  |  | 
|  |  | 



Volumes
|  |  | 
|  |  | 
|  |  | 
|  |  | 




