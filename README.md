# Kubernetes Notes

---

## 📌 Kubernetes Architecture

### 🧠 Master Node
- **API Server** → Kubernetes API entry point (all components communicate through it)
- **Scheduler** → Assigns Pods to Worker Nodes
- **Controller Manager** → Handles cluster maintenance (replication, node failures, etc.)
- **etcd** → Stores cluster configuration

### ⚙️ Worker Node
- **Kubelet** → agent to Communicates with master, manages Pods
- **Kube-proxy** → Handles networking between app components & load balancing
- **Container Runtime** → the engine runs the containers (Podman, Docker, **containerd** (used in NAB)...)

---

## 🧪 Basic Commands

```bash
kubectl run my-pod --image=nginx:alpine
kubectl get nodes
kubectl describe pods <POD\\\_NAME>
kubectl log pod\_name
kubectl get po -A | grep scheduler or check directly in kube-system namespace. To check for scheduler running for instance where Pod not in ready states
```

---

## 🚨 Pod States & Probes

### CrashLoopBackOff
- Pod starts → crashes → repeats  
- Causes:
  - Config issues
  - Missing secrets
  - Init container failure
  - PV issues

### Probes

| Probe Type       | Purpose |
|----------------|--------|
| **Liveness Probe** | It's used to restart a container when it reaches a non-desired state. Prevents stuck containers consuming resources forever..|
| **Readiness Probe** | used by Kubelet to know when a container is ready to start running, accepting traffic. - Like a health check. Used for warmup or db connection to prevent traffic to unready pods. |
| **Startup Probe** | Prevents liveness probe from killing long-initializing container pod during startup. Only active until pod successfully starts. |

> StartupProbe overrides LivenessProbe

---

## 🏷️ Labels & Selectors

### Labels
- Key-value pairs attached to Kubernetes objects (pods, services, deployments)
- Used for grouping and identification

### Selectors
- Match resources using labels

**Used by:**
- Services → route traffic
- Deployments → manage Pods
- 
Services use selectors to route traffic to the right pods
Deployments use selectors to manage the correct set of pods
> If labels & selectors don’t match → no traffic routing

---

## 🚀 Deployment
- Declarative definition for Pods & ReplicaSets

---

## 🌐 Services

### Key Checks
- `targetPort` matches container `containerPort`
- Selector matches Pod labels

### Service Types

| Type | Description |
|------|------------|
| **ClusterIP** | Default service type, Exposes service inside cluster only, Provides stable virtual IP (not pod IP) for pods |
| **NodePort** |  Exposes service on <NodeIP>:Port. Opens port on every node |
| **LoadBalancer** | Creates external cloud load balancer, Routes traffic into cluster |
| **Ingress** |  L7 (HTTP/HTTPS) routing, Routes traffic based on host/path to service. Replace multiple load balancer for each service. |

> Service endpoint are nothing but Endpoints with pod IPs + target ports like backen

---

## 🌍 Ingress

route traffic from outside the Kubernetes cluster to services within a cluster
Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource."

### Ingress Controller
Actual component (NGINX / HAProxy / Istio Gateway). Watches Ingress rules and implements routing.

Ingress is not a service and not a pod — it’s just a rule definition. The Ingress Controller is what actually processes traffic. Cluster might have only one controller installed with multiple ingress config file for each service.

> Ingress = rules only (not a service/pod)

### Enterprise Flow

In enterprise setups with a shared NLB, new services are onboarded by creating a ClusterIP service and updating Ingress rules. The NLB remains unchanged since it only forwards traffic to the Ingress Controller, which handles routing internally.”

```
Client (api.bank.com)
   ↓
DNS (route53) → NLB (pre-created / AWS) (Target group is worker node with nodeport 8080 where the Ingress controller pod was listening.
   ↓
Ingress Controller (NGINX/HAProxy)
   ↓
Ingress rules (path/host based routing)

   ↓
ClusterIP Service
   ↓
Pod
   ↓
HAProxy sidecar (mTLS)
   ↓
Application
```

---

## 🚪 Gateway API / Istio

- Gateway API replaces Ingress (not NGINX itself)
- Better for multi-team environments

### Istio
- Service mesh
- Features:
  - mTLS
  - Traffic control
  - Observability

---

## ☁️ EKS Deployment

- Control plane → AWS managed
- Worker nodes → in VPC
- Networking → VPC CNI
- Exposure → Ingress + NLB

---

## 🔁 DaemonSet
- Runs a Pod on every node
- Used for logging & monitoring

---

## 💾 Storage

### Volume Types

| Type | Description |
|------|------------|
| **emptyDir** | Temporary (Pod lifecycle) |
| **hostPath** | Access host filesystem |

### Persistent Storage

- PV → actual storage (EBS)
- PVC → request
- StorageClass → dynamic provisioning

```
Pod → PVC → StorageClass → PV → AWS EBS
```

### Use Cases
- Logs & metrics
- Caching
- Shared storage between Pods
- Batch jobs

---

## 🔐 RBAC

### Components

| Component | Purpose |
|----------|--------|
| Role / ClusterRole | Define permissions |
| RoleBinding / ClusterRoleBinding | Assign permissions |

### Flow

```
Role → RoleBinding → ServiceAccount → Pod
```

### Notes
- Uses ServiceAccounts
- IRSA maps Kubernetes SA → AWS IAM Role

---

## ⚙️ Config Management

| Type | Purpose |
|------|--------|
| **ConfigMap** | Non-sensitive data |
| **Secret** | Sensitive data |

---

## 🧱 Namespace

- Logical isolation
- Acts as virtual cluster

> Deleting namespace deletes all resources inside

---

## 📊 Resource Management

### Resource Quota
- Limits total usage per namespace
- Covers: Pods, Services, PVs, etc.

### Resource Limits

| Type | Description |
|------|------------|
| Request | Minimum guaranteed |
| Limit | Maximum allowed |

> CPU → throttled  
> Memory → OOMKilled

---

## 📦 Helm

### Structure

```
my-app/
  Chart.yaml
  values.yaml
  templates/
    deployment.yaml
    service.yaml
    ingress.yaml
  charts/
```

### Commands

```bash
helm install my-app
helm upgrade --install my-app ./chart -f values-dev.yaml --set image.tag=v2
helm template my-app ./chart
```

---

## 🎯 Scenarios

### Cost Optimization
- Right-size resource requests → better bin-packing → fewer nodes

### Reduce Blast Radius
- Use:
  - Namespaces
  - Quotas
  - Multi-AZ
  - Controlled disruptions

---

## 🛠️ Troubleshooting

### Pods Running but Traffic Fails
- Check:
  1. Ingress
  2. Service endpoints
  3. Readiness
  4. Pod logs
  5. Sidecar / network

### Pods Restarting
- OOMKilled
- Liveness probe failure
- Dependency issues

### Pod Not Scheduling
- `kubectl describe pod`
- Check:
  - Resources
  - Node selectors
  - Taints/tolerations
  - PVC binding
  - VPC CNI IP exhaustion

---

## 📜 Logging

- Node-level logging using DaemonSet
- Tools: Fluent Bit / Splunk Forwarder
- Logs path:

```
/var/log/containers
```

---

## 🐳 Docker Commands

### Containers

| Command | Description |
|--------|------------|
| `docker ps` | Running containers |
| `docker ps -a` | All containers |
| `docker run -d -p 8080:80 nginx` | Run container |
| `docker stop <container>` | Stop |
| `docker start <container>` | Start |
| `docker restart <container>` | Restart |
| `docker rm <container>` | Remove |

---

### Images

| Command | Description |
|--------|------------|
| `docker build -t myapp:latest .` | Build image |
| `docker images` | List images |
| `docker rmi <image>` | Remove image |
| `docker pull nginx` | Pull image |

---

### Logs & Debugging

| Command | Description |
|--------|------------|
| `docker logs <container>` | View logs |
| `docker logs -f <container>` | Follow logs |
| `docker exec -it <container> /bin/sh` | Shell access |
| `docker inspect <container>` | Detailed info |

---

### Networking

| Command | Description |
|--------|------------|
| `docker network ls` | List networks |
| `docker network create my-net` | Create network |
| `docker run --network my-net ...` | Use network |
| `docker system prune -a` | Cleanup |
| `docker rm $(docker ps -aq)` | Remove all containers |

---

### Volumes

| Command | Description |
|--------|------------|
| `docker volume ls` | List volumes |
| `docker volume create my-vol` | Create volume |
| `docker run -v my-vol:/data ...` | Mount volume |

---
