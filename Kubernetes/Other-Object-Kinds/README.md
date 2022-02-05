DaemonSets:

DaemonSets are a great way to ensure a pod replica runs dynamically on each node. They even automatically handle the creation and removal of such pods when nodes join or leave the cluster. 

In this case, use DaemonSets to run pods on all nodes in an existing cluster.

StaticPods:

Managed directlt by worker node not by control plane. Static Pods are always bound to one Kubelet on a specific node.

Place the yaml file in worker node manigest path. It is specifically placed in a location of worker node.

Use the staticPodPath: <the directory> field in the kubelet configuration file, which periodically scans the directory and creates/deletes static Pods as YAML/JSON files appear/disappear there.

   Execute to find the kubelet service file: systemctl status kubelet
   Add this to that service file to provide the location of pod file: --pod-manifest-path=/home/pod-location
   And Restart the kubelet: sudo systemctl restart kubelet


Mirror Pods:

Kubelet will create a mirror pod for each static pod. Mirror pods allows you to see the status of static pods via ki8s api.
But will not be able to change or manage them via the API. It is just a ghost of static pod.