# from base image node
# ARG: ARG is used to pass some arguments to consecutive instructions and this is only command other than a comment can be used before FROM.
#diff ARG & ENV : if you need build-time customization, ARG is your best choice.
#If you need run-time customization (to run the same image with different settings), ENV is well-suited. You can change the workdirectory later during container runtime to different value
ARG NODE_VERSION=8.11-slim
FROM node:$NODE_VERSION

#LABEL : metadata ifnormation
LABEL "about"="This file is just am example to demonstarte the LABEL"

#ENV: ENV sets the environment variables for the subsequent instructions in the build stage. we used that later with $
#form1 : ENV param value 
#form2 : ENV param1=value1,param2=value2
ENV workdirectory /usr/node

#WORKDIR: sets the working directory for all the consecutive commands. we can have multiple WORKDIR commands and will be appended with a relative path. Below will append /usr/node/app
WORKDIR $workdirectory
WORKDIR app

#copy just copies the file from src to destination
COPY package.json .

RUN ls -ll &&\
    npm install

RUN useradd bhargav

#USER instruction sets the user name and optionally the user group to use when running the image and for any instructions that follow it in the Dockerfile
USER bhargav

#ADD: ADD is used to add files or directories and remote files from URL from source host filesystem to a destination in the container file system. It extracts any zip contnets as well
ADD index.js .

RUN ls -l

#CMD --> CMD is an instruction that is best to use if you need a default command which users can easily **override**. If a Dockerfile has multiple CMDs, it only applies the instructions from the last one.  
#you can list multiple but the last one will be executed

#Entrypoint --> ENTRYPOINT is preferred when you want to define a container with a specific executable. You cannot override an ENTRYPOINT when starting a container unless you add the --entrypoint flag.
#Combine ENTRYPOINT with CMD if you need a container with a specified executable and a default parameter that can be modified easily
# command executable and version
ENTRYPOINT ["node"]

#Expose: EXPOSE is used as documentation for the port. This is just a communication between the person who builds the image and the person who runs the container. It doesn’t serve any other purpose other than documentation.
#For example, we have used port 3070 in the index.js file. So, we are letting people know who runs the container by using EXPOSE instruction in the Dockerfile.
EXPOSE 3070

#HEALTHCHECK NONE (disable any healthcheck inherited from the base image)
#There can only be one HEALTHCHECK instruction in a Dockerfile.
#to check every five minutes or so that a web-server is able to serve the site’s main page within three seconds:
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:3070/ || exit 1
