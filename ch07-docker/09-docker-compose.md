# Run Multiple Containers with Docker Compose

`mongo.yaml`:

```yaml
version: '3'
services:
    mongodb:
        image: mongo
        ports:
            - 27017:27017
        environment:
            - MONGO_INITDB_ROOT_USERNAME=username
            - MONGO_INITDB_ROOT_PASSWORD=password

    mongo-express:
        image: mongo-express
        ports:
            - 8080:8080
        environment:
            - ME_CONFIG_MONGODB_ADMINUSERNAME=username
            - ME_CONFIG_MONGODB_ADMINPASSWORD=password
            - ME_CONFIG_MONGODB_SERVER=mongodb
```

**Note:** Docker-compose takes care of creating a common network for the created containers *implicitly*.

## Start Containers w/ Docker Compose file
- `docker compose -f <docker-compose-file> up`

## Stop Containers w/ Docker Compose file
- `docker compose -f <docker-compose-file> down`