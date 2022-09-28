# Docker Volumes Demo

`docker-compose.yaml`:

```yaml
version: '3'
services:

    mongodb:
        image: mongo
        ports:
        - 27017:27017
        environment:
            - MONGO_INITDB_ROOT_USERNAME=admin
            - MONGO_INITDB_ROOT_PASSWORD=password
        volumes:
            - mongo-data:/data/db # Attach named volume of host to fs location of container
    mongo-express:
        image: mongo-express
        ports:
            - 8080:8081
        environment:
            - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
            - ME_CONFIG_MONGODB_ADMINPASSWORD=password
            - ME_CONFIG_MONGODB_SERVER=mongodb
volumes:
    mongo-data:
        driver: local
```

## Docker Volume Locations

### HOST Locations
1. Windows: `C:\ProgramData\docker\volumes`
2. Linux/Mac: `var/lib/docker/volumes`

Each anonymous volume will be identified by its own unique hash followed by `/_data`. Named volumes will be identified by name.