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

docker-compose -d up

docker-compose down

#Docker Networking
Bridge: Default --> localhost IP --> docker hostt IP with port --> container port
