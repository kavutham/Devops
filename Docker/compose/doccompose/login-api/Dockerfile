# from base image node
FROM node:8.11-slim

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN echo "WORK DIRECTORY!!!!"

# copying all the files from your file system to container file system
COPY package.json .

# install all dependencies
RUN npm install

#expose the port
EXPOSE 3070

# command to run when intantiate an image
CMD ["npm","start"]