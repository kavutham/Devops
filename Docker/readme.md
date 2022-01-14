Dockerfile --> (docker build) Image --> (docker run) --> container 

docker inspect

docker images --> print the avaiable images that we created using a docker file or puling (docker pull) the image directly from dockerhub

docker ps --> all the running container in our docker host

docker logs --> check logs after container running --> debug application

docker attach --> attach to the running container with the default command that it started with.

docker exec --> enter or open into that running cotainer


docker exec -it container-name /bin/sh
