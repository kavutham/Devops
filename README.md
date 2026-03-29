# Kubernetes & Docker Engineering

Welcome! I'm passionate about **container orchestration**, **cloud infrastructure**, and **distributed systems**. This repository contains my reference guide and notes on Kubernetes, Docker, and related technologies.

---

## 📚 Table of Contents

- [Kubernetes](#kubernetes)
- [Docker](#docker)
- [Troubleshooting & Best Practices](#troubleshooting--best-practices)

---

## Kubernetes

### Architecture Overview

#### Master Node Components
- **API Server** - the Kubernetes API. All cluster components communicate through it
- **Scheduler** - assigns an application with a worker node it can run on
- **Controller Manager** - cluster maintenance (replications, node failures, etc.)
- **etcd** - stores cluster configuration

#### Worker Node Components
- **Kubelet** - an agent responsible for node communication with the master
- **Kube-proxy** - load balancing traffic between app components
- **Container runtime** - the engine runs the containers (Podman, Docker, **containerd** (used in NAB)...)

### Essential kubectl Commands

```bash
kubectl run my-pod --image=nginx:alpine
kubectl get nodes
kubectl describe pods <POD_NAME>
kubectl log pod_name
kubectl get po -A | grep scheduler
# or check directly in kube-system namespace to check for scheduler running
# (e.g., where Pod not in ready states)
```

### Pod Health & Lifecycle Management

| Probe Type | Purpose |
|-----------|---------|
| **CrashLoopBackOff** | Pod starting, crashing, and repeats. Possible reasons: configuration issue, secrets missing, init-container fail, or PV connection issue |
| **Liveness Probe** | Restarts a container when it reaches a non-desired state. Prevents stuck containers consuming resources forever |
| **Readiness Probe** | Used by Kubelet to know when a container is ready to start running and accepting traffic. Like a health check. Used for warmup or DB connection to prevent traffic to unready pods |
| **Startup Probe** | Prevents liveness probe from killing long-initializing container pod during startup. Only active until pod successfully starts |

**Note:** StartupProbe overrides LivenessProbe

### Labels & Selectors

**Labels:**
- Key-value pairs attached to Kubernetes objects (pods, services, deployments)
- Used to organize, group, and identify resources

**Selectors:**
- Used to find and match resources based on labels
- Services use selectors to route traffic to the right pods
- Deployments use selectors to manage the correct set of pods
- **Important:** If labels and selectors don't match → service won't send traffic
- Selectors are how Kubernetes decouples components

### Deployments

**Deployment** is a declarative statement for the desired state for Pods and Replica Sets.

### Services

#### Key Configuration Steps

1. Make sure that **targetPort** of the Service is matching the **containerPort** of the Pod
2. Make sure that **selector** matches at least one of the Pod's labels

#### Service Types

| Type | Purpose |
|------|---------|
| **ClusterIP** | Default service type. Exposes service inside cluster only. Provides stable virtual IP (not pod IP) for pods |
| **NodePort** | Exposes service on `<NodeIP>:Port`. Opens port on every node |
| **LoadBalancer** | Creates external cloud load balancer. Routes traffic into cluster |

**Service Endpoints:** Nothing but Endpoints with pod IPs + target ports (backend).

### Ingress

**Purpose:** Route traffic from outside the Kubernetes cluster to services within a cluster.

Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.

#### Ingress Controller

- **Actual component:** NGINX / HAProxy / Istio Gateway
- Watches Ingress rules and implements routing
- **Important:** Ingress is not a service and not a pod — it's just a rule definition
- The Ingress Controller is what actually processes traffic
- Cluster might have only one controller installed with multiple ingress config files for each service

#### Enterprise Setup Pattern

In enterprise setups with a shared NLB, new services are onboarded by:
1. Creating a ClusterIP service
2. Updating Ingress rules
3. The NLB remains unchanged since it only forwards traffic to the Ingress Controller, which handles routing internally

### Gateway API (Modern Alternative to Ingress)

**Why Gateway API replaces Nginx/Ingress:**
- Separates infrastructure ownership from application routing
- More suitable for large-scale, multi-team environments compared to Ingress

**Key Changes:**
- Gateway API replaces Ingress resource, **not NGINX itself**
- Replace `kind: nginx` to `kind: gateway` & `kind: httproute`

### Istio Service Mesh

**Configuration:**
- Use `kind: gateway`, `virtualservice`, `destinationrule`

Istio replaces both the ingress controller and custom sidecar proxies by introducing a service mesh. It uses:
- **Ingress Gateway** for north-south traffic
- **Envoy sidecars** for east-west communication
- Built-in mTLS, traffic control, and observability

#### Traffic Flow Diagram

```
Client (api.bank.com)
         ↓
DNS (route53) → NLB (pre-created / AWS)
    (Target group is worker node with nodeport 8080 where the Ingress controller pod was listening)
         ↓
Ingress Controller (NGINX/HAProxy)
         ↓
Ingress rules (path/host based routing)
         ↓
ClusterIP Service
         ↓
Pod
         ↓
HAProxy sidecar → handles mTLS
         ↓
Application container
```

### EKS Deployment on AWS

**Deployment Methods:**
- Using `eksctl` or `terraform`

**Architecture:**
- AWS manages the control plane
- We provision worker nodes in a VPC
- Networking is handled by the VPC CNI plugin
- Applications exposed using an ingress controller backed by an NLB
- Applications deployed via deployments
- Exposed internally using ClusterIP services
- Routed externally using ingress rules

### DaemonSet

Ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them.

**Use Cases:** Monitoring and logging

### Volumes

#### Volume Types

| Type | Description |
|------|-------------|
| **emptyDir** | Cease to exist when pod is not running |
| **hostPath** | Mounts a path from the host itself to access some internal host paths (e.g., `/sys`, `/var/lib`) |

**Ephemeral vs Persistent:**
- Ephemeral volume types have the lifetime of a pod
- Persistent volumes exist beyond the lifetime of a Pod

#### Persistent Volumes

Persistent Volumes allow us to save data so basically they provide storage that doesn't depend on the pod lifecycle. Actual storage usually EBS.

**Types:** NFS, iSCSI

**Key Concept:** PVC requests storage, PV provides it, StorageClass automates provisioning

**Provisioning Flow:**
```
Pod → PVC → StorageClass → (creates) PV → AWS EBS
```

**Without StorageClass:** You need to manually create PV each time it's exhausted.

**Use Cases:**
- Log metrics and data
- Caching internal API response rather than S3 repeatedly
- Shared file process between pods
- Batch jobs

### RBAC (Role-Based Access Control)

**Components:**
- **Role/ClusterRole** - defines permissions
- **RoleBinding/ClusterRoleBinding** - assigns them to identities like users or service accounts

**Authorization Flow:**
```
Role → RoleBinding → ServiceAccount → Pod
(Service account mentioned in deployment kind spec)
```

**Best Practice:**
- Uses roles and bindings to define permissions
- Use ServiceAccounts with RBAC for Kubernetes-level access
- Use IRSA (IAM Roles for Service Accounts) using annotations inside `kind: ServiceAccount` to map AWS IAM roles for cloud permissions
- Ensures least privilege for applications and CI/CD pipelines

### ConfigMap

- Stores non-sensitive configuration data
- Used for environment variables, configs

### Secret

- Stores sensitive data (passwords, tokens)
- Used for secure application configs

### Namespace

- Provides isolation, virtual cluster within cluster
- Groups your resources together
- Deleting a namespace will delete the resources within
- **Note:** Volumes cannot be created within Namespace

### Resource Management

**Resource Quota:**
- Provides constraints that limit aggregate resource consumption per namespace
- Includes pods, service, PV, ingress, etc.
- Prevents one namespace from exhausting cluster resources

**Resource Limit:**
- Applies at container level how much CPU and Memory to use
- Request & Limits
- Charged on Request; Limit generally 2x or 3x than Request and acts as scaling unit
- CPU high can be throttled
- Memory exceeding limit causes OOMKill

### HELM Charts

Helm is a package manager for Kubernetes that templates and manages application deployments using reusable charts.

#### Chart Structure

```
my-app/
    Chart.yaml         # metadata (name, version)
    values.yaml        # default values (variables)
    templates/         # Kubernetes YAML templates
        deployment.yaml
        service.yaml
        ingress.yaml
    charts/            # dependencies (optional)
```

#### Common HELM Commands

```bash
# New deploy
helm install my-app

# Update existing or install
helm upgrade --install my-app ./chart -f values-dev.yaml --set image.tag=v2

# Delete app
helm template my-app ./chart
```

#### Cost Optimization Scenario

We right-sized container requests based on actual usage metrics, improving bin-packing efficiency and reducing node count, which lowered infrastructure cost.

### Blast Radius Reduction

Blast radius is reduced using:
- Isolation
- Quotas
- Multi-AZ deployments
- Controlled disruptions

---

## Docker

### Containers

| Command | Description |
|---------|-------------|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers (including stopped) |
| `docker run -d -p 8080:80 nginx` | Run container in background with port mapping |
| `docker stop <container>` | Stop a running container |
| `docker start <container>` | Start stopped container |
| `docker restart <container>` | Restart container |
| `docker rm <container>` | Remove container |

### Images

| Command | Description |
|---------|-------------|
| `docker build -t myapp:latest .` | Build image from Dockerfile |
| `docker images` | List images |
| `docker rmi <image>` | Remove image |
| `docker pull nginx` | Pull image from registry |

### Logs & Debugging

| Command | Description |
|---------|-------------|
| `docker logs <container>` | View logs |
| `docker logs -f <container>` | Follow logs (live) |
| `docker exec -it <container> /bin/sh` | Enter container shell |
| `docker inspect <container>` | Detailed container info (JSON) |

### Networking

| Command | Description |
|---------|-------------|
| `docker network ls` | List networks |
| `docker network create my-net` | Create custom network |
| `docker run --network my-net ...` | Attach container to network |
| `docker system prune -a` | Remove unused containers, images, networks |
| `docker rm $(docker ps -aq)` | Remove all containers |

### Volumes

| Command | Description |
|---------|-------------|
| `docker volume ls` | List volumes |
| `docker volume create my-vol` | Create volume |
| `docker run -v my-vol:/data ...` | Mount volume |

---

## Troubleshooting & Best Practices

### Pods Running but Traffic Intermittently Fails

Debug flow:
```
Ingress → Service Endpoints → Readiness → Pod Logs → Sidecar/Network Layer
```
Check for HAProxy issues, TLS handshake issues, etc.

**Debug Steps:**
- Check ingress configuration and rules
- Verify service endpoints and pod IPs
- Review readiness probe status
- Examine pod logs for errors
- Inspect sidecar proxy (HAProxy) logs for connection issues

### Pods Keep Restarting but No Clear Logs

Check for:
- **OOMKilled?** - Memory exhausted or CPU issues
- **Liveness probe?** - Liveness causing restart if health check fails
- **Dependency failure?** - DB not connecting, incorrect DB credentials, incorrect secret or configs

**Investigation Steps:**
1. Check events: `kubectl describe pod <POD_NAME>`
2. Review liveness probe configuration
3. Verify resource requests and limits
4. Check external dependencies (databases, APIs)
5. Validate secrets and ConfigMaps

### POD Not Getting Scheduled

Start with:
1. `kubectl describe pod` - check scheduling events
2. Verify resource availability per node
3. Check node selectors, taints/tolerations, and PVC binding issues
4. Check IP exhaustion due to VPC CNI limits (can prevent pods from being scheduled even if CPU/memory is available)

**Common Causes:**
- Insufficient CPU or memory
- Node selector mismatch
- Taint/toleration mismatch
- PVC not bound
- VPC CNI IP exhaustion

### Logging

In EKS setup, logging was handled at the node level using a DaemonSet-based agent like Fluent Bit or Splunk Forwarder, which:
- Collected container logs from the node filesystem
- Pushed them to Splunk
- Avoided the need for per-container logging configuration
- Provided centralized observability across all services

**Log Location:** `/var/log/containers`

### General Best Practices

- **Start debugging from the layers:** Application → Container → Pod → Service → Ingress
- **Monitor resource usage:** CPU throttling and OOMKills are common issues
- **Use probes effectively:** Combine startup, readiness, and liveness probes appropriately
- **Plan for multi-tenancy:** Use namespaces, resource quotas, and RBAC
- **Centralize logging:** Avoid per-container logging in large clusters
- **Automate deployments:** Use HELM for templating and consistency
- **Right-size resources:** Use actual metrics to set appropriate requests and limits
- **Design for resilience:** Multi-AZ deployments, pod disruption budgets, and proper health checks

---

## 📞 Connect with Me

Feel free to reach out if you have questions about Kubernetes, Docker, or cloud infrastructure!

---

**Last Updated:** March 29, 2026
