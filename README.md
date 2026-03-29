# Kubernetes — Full Study Notes

## Table of Contents
1. Core Components  
2. Probes  
3. Labels & Selectors  
4. Deployments & Services  
5. Ingress & Gateway API  
6. Traffic Flow (AWS EKS)  
7. Storage (PV, PVC, StorageClass)  
8. RBAC  
9. ConfigMaps & Secrets  
10. Namespaces & Resource Management  
11. Helm  
12. Troubleshooting  
13. Logging  
14. Docker  

---

# 1. Core Components

## Master Node Components

### API Server
Central control-plane component.  
All cluster components communicate through it using the Kubernetes API.

### Scheduler
Assigns pods to nodes based on resource availability and scheduling rules.

### Controller Manager
Handles cluster automation such as:
- Replication  
- Node lifecycle  
- Endpoint management  

### etcd
Distributed key-value store holding the entire cluster state.

---

## Worker Node Components

### Kubelet
Node agent ensuring containers are running and reporting status to the control plane.

### Kube-proxy
Manages networking rules and load-balances traffic between pods.

### Container Runtime
Runs containers inside pods.  
Examples: Docker, Podman, **containerd**.

---

## Useful kubectl Commands
```bash
kubectl run my-pod --image=nginx:alpine
kubectl get nodes
kubectl describe pods <POD_NAME>
kubectl logs pod_name
kubectl get po -A | grep scheduler
