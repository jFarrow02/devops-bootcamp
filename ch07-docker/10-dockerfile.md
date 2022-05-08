# Building Images with Dockerfile

## What is a Dockerfile?
A **Dockerfile** is a blueprint for building images.

`Dockerfile`:
```sh
FROM node

RUN mkdir -p /home/app # execute any linux commands INSIDE the container

COPY . /home/app # copy current folder files from host to container

CMD["node", "/home/app/server.js"] # execute entrypoint command

```

## Build Image w/ Dockerfile

- `docker build -t <image-name>:<tag> <dockerfile-location>`

**Note:** in real life, you would want to build an artifact FIRST, and then copy the artifact into the image in the `COPY` step.

## EXAMPLE: Create a Node app from Dockerfile (Using Packaged app)

```Dockerfile
FROM node:18-alpine3.14

RUN mkdir -p /testapp

COPY testapp-1.0.0.tgz  /testapp

WORKDIR /testapp

RUN tar -xf /testapp/testapp-1.0.0.tgz

RUN pwd

RUN ls -la /testapp

WORKDIR /testapp/package

RUN pwd

RUN ls -la

RUN npm install

EXPOSE 8080

CMD ["node", "server.js"]

```