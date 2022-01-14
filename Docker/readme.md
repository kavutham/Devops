Dockerfile --> (docker build) Image --> (docker run) --> container 

docker inspect

docker images --> print the avaiable images that we created using a docker file or puling (docker pull) the image directly from dockerhub

docker ps --> all the running container in our docker host

docker logs --> check logs after container running --> debug application

docker attach --> attach to the running container with the default command that it started with.

docker exec --> enter or open into that running cotainer

CMD --> CMD is an instruction that is best to use if you need a default command which users can easily **override**. If a Dockerfile has multiple CMDs, it only applies the instructions from the last one.

Entrypoint --> ENTRYPOINT is preferred when you want to define a container with a specific executable. You cannot override an ENTRYPOINT when starting a container unless you add the --entrypoint flag.
Combine ENTRYPOINT with CMD if you need a container with a specified executable and a default parameter that can be modified easily


docker exec -it container-name /bin/sh
