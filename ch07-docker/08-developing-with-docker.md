# Developing with Docker

## Setup mongodb/mongo-express as containers

1. `docker pull mongo:latest`
2. `docker pull mongo-express:latest`

### Connect mongo and mongo-express w/ Docker Network
A **Docker network** allows docker containers to communicate with one another using **just the container name**. Applications outside the network must communicate using the full host name/port number.

Once the application is inside the network, it can communicate using the container name.

#### List Docker networks
- `docker network ls`

#### Create a new network
- `docker network create <network-name>`

3. `docker network create mongo-network`
4. `docker run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=username -e MONGO_INITDB_ROOT_PASSWORD=password --name <container-name> --net <network-name> mongo`
5. `docker run -d -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=username -e ME_CONFIG_MONGODB_ADMINPASSWORD=password --name <container-name> --net <network-name> mongo-express`

## Connect to DB from Front-end Application
- Must authenticate to db using hostname (`localhost` in this case), `username` value and `password` value. See mongo docs for connection string construction.