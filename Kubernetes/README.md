## Basic Commands and Explanation
 
	**exec alllows any process within the container:** kubectl exec --stdin --tty mongo-75f59d57f4-5z52g -- /bin/bash
	
	**attach to the main process run by the container:** kubectl attach redis -i
	
 	**Create and run a particular image in a pod:** kubectl run -i --tty busybox --image=busybox --restart=Never -- sh
	
 	**to switch to namespace:** kubectl config set-context --current --namespace=my-namespace
	
	**portforward:** kubectl port-forward svc/frontend 8080:80
	
	**HPA:** kubectl autoscale rs frontend --max=10 --min=3 --cpu-percent=50

## Networking:
**Conatiner in same pod:**

	Network namespace a collection of network interfaces (connections between two pieces of equipment on a network) and routing tables (instructions for where to send network packets).
    Each pod on a node has its own network namespace. Each pod has its own IP address
    There’s a secret container that runs on every pod in Kubernetes. This container’s #1 job is to keep the namespace open in case all the other containers on the pod die. 
    It’s called the pause container.
    
 **Pods with other pods in same node:**
 
    A virtual ethernet device is a tunnel that connects the pod’s network with the node. 
    This connection has two sides – on the pod’s side, it’s named eth0, and on the node’s side, it’s named vethX (Veth1, Veth2).
    In Kubernetes, the Network bridge is called cbr0
    
**Pods with other pods of different node in cluster:**

    At the cluster level, there’s a router table that maps IP address ranges to various nodes. Pods on those nodes will have been assigned IP addresses from those ranges.
    Then this table will store the fact that IP addresses that look like 100.96.1.xxx should go to node 1, and addresses like 100.96.2.xxx need to go to node 2.
    
    kube-proxy manages forwarding of traffic addressed to the virtual IP addresses (VIPs) of the cluster's Kubernetes Service objects to the appropriate backend pods

## Pod:
    When a Pod runs multiple containers, the containers are managed as a single entity and share the Pod's resources. All the containers in the pod share same network space (resource)
    Pods has it own ip address so when it dies, its ip is also lost. To make communication still, we need service tagged to pods using selector tag
    whcih will be running always even if the pod dies.

## Images: 
	To use an image without uploading it, you can follow these steps: It is important that you be in same shell since you are setting environment variables!
	1. Set the environment variables with eval $(minikube docker-env)
	2. Build the image (eg docker build -t my-image .)
	3. Set the image in the pod spec like the build tag (eg my-image)
	4. Set the imagePullPolicy to Never, otherwise, Kubernetes will try to download the image.
Default the pull policy of all containers in that pod will be set to IfNotPresent if not specfied

## Containers:
    There are three ways that containers in the pod communicate with each other.
    1. Shared Network Namespace, 
    2. Shared Storage Volumes, and 
    3. Shared Process Namespace.
 
## Daemonset:
    Use a DaemonSet instead of a ReplicaSet for Pods that provide a machine-level function, such as machine monitoring or machine logging. 
    These Pods have a lifetime that is tied to a machine lifetime. They can not be autoscaled

## Service:    
**ClusterIP:** 
Exposes the Service internally to the cluster. This is the default setting for a Service. However a Kubernetes user you can use kubectl port-forward to access the service even though it uses a ClusterIP.

**NodePort:** 
Exposes the Service to the internet from the IP address of the Node at the specified port number. You can only use ports in the 30000-32767 range.

    kubectl expose deployment my-deployment-50000 --name my-np-service --type NodePort --protocol TCP --port 80 --target-port 50000

**LoadBalancer:** 
This will create a load balancer assigned to a fixed IP address in the cloud, so long as the cloud provider supports it. In the case of Linode, this is the responsibility of the Linode Cloud Controller Manager, which will create a NodeBalancer for the cluster. This is the best way to expose your cluster to the internet.
    
    kubectl expose deployment my-deployment-50001 --name my-lb-service --type LoadBalancer --port 60000 --target-port 50001
    
**Cloud provider LB Caveats:** Every Service that you deploy as LoadBalancer will get it’s own IP. difficulty of managing lots of different IPs. The LoadBalancer is usually billed based on the number of exposed services, which can be expensive.

**ExternalName:** Maps the service to a DNS name by returning a CNAME record redirect. ExternalName is good for directing traffic to outside resources, such as a database that is hosted on another cloud.

**Headless:** You can use a headless service in situations where you want a Pod grouping, but don't need a stable IP address.

**Ingress:** Ingress isn’t a type of Service, but rather an object that acts as a reverse proxy and single entry-point to your cluster that routes the request to different services.The most basic Ingress is the NGINX Ingress Controller, where the NGINX takes on the role of reverse proxy, while also functioning as SSL
    
**Several ways to route external traffic into your cluster:**
    Using Kubernetes proxy and ClusterIP (kubectl proxy)
    Exposing services as NodePort
    Exposing services as LoadBalancer
    
## Volumes:

**A PersistentVolume (PV):** is a piece of storage in the cluster that has been provisioned by server/storage/cluster administrator or dynamically provisioned Using Storage Classes. It is a resource in the cluster just like node.

**A PersistentVolumeClaim (PVC):** is a request for storage by a user which can be attained from PV. It is similar to a Pod. Pods consume node resources and PVCs consume PV resources. Pods can request specific levels of resources (CPU and Memory). 

Claims can request specific size and access modes (e.g., they can be mounted ReadWriteOnce, ReadOnlyMany or ReadWriteMany.
