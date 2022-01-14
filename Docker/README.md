## Docker Basic Instructions
Dockerfile --> (docker build) Image --> (docker run) --> container 

Dockerfile can be named as like purpose.Dockerfile, Dockerfile.purpose, Dockerfile.

Default it will automatically runs Dockerfile if not specified anything during docker build

## Docker Commands
docker inspect --> inspect image or container about it's details and information

docker images --> print the avaiable images that we created using a docker file or puling (docker pull) the image directly from dockerhub

docker ps --> all the running container in our docker host

docker logs --> check logs after container running --> debug application

docker attach --> attach to the running container with the default command that it started with.

docker exec --> enter or open into that running cotainer

docker exec -it container-name /bin/sh

docker commit <conatainer id> <username/imagename>  --> This command creates a new image of an edited container on the local system

docker-compose -d up

docker-compose down

## Docker Networking
  
**Bridge:** (Default Network if not assigned any)
  
In Bridge network all containers will be assigned with intenral IP address and they can communicate with each other. But they can’t communicate outside the bridge network.
With -p flag however, we can map the docker port to the native port.
 
docker run -p 80:80 dockerimage
  
**Host:**
  
This driver removes the network isolation between the docker host and the docker containers to use the host’s networking directly. So with this, you will not be able to run multiple  containers on the same host, on the same port as the port is now common to all containers in the host network. No indiviual IP instead all share same host IP
  
**None:**
  
Containers are not attached to any network and do not have any access to the external network or other containers. So, this network is used when you want to completely disable the networking stack on a container and, only create a loopback device. Like for monitoring purpose or some other loggin jobs.
  
**Overlay**
  
Creates an internal private network that spans across all the nodes participating in the swarm cluster. So, Overlay networks facilitate communication between a swarm service and a standalone container, or between two standalone containers on different Docker Daemons
  
**Macvlan:**
  
Allows you to assign a MAC address to a container, making it appear as a physical device on your network. As a result, each of the containers have a full TCP/IP stack of their own Then, the Docker daemon routes traffic to containers by their MAC addresses. Macvlan driver is the best choice when you are expected to be directly connected to the physical network, rather than routed through the Docker host’s network stack.
