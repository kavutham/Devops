FROM node:latest

RUN mkdir -p /app/src

WORKDIR /app/src

COPY package.json .

#RUN npm install -g npm@7.7.0
RUN npm install

COPY . .

EXPOSE 3000

#after container creation only
CMD ["npm", "start"]
#CMD ["Executable" "argaument"]

#RestartPolicy Always




