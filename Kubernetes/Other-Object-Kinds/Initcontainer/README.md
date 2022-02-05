**InitContainer:**

They run once during the startup process of pod. A pod can have any number of init containers and they will run once in order to completion.

A pod's app container wait till init containers complete

If a Pod's init container fails, the kubelet repeatedly restarts that init container until it succeeds. However, if the Pod has a restartPolicy of Never, and an init container fails during startup of that Pod, Kubernetes treats the overall Pod as failed.

use case: 

1. wait for another kubernetes resource to be created before finishing startup

2. Populate data into a shared volume at startup

3. Communicate with external service or check if API is available 
