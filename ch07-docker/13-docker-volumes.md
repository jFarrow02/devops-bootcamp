# Docker Volumes

Docker volumes are used for **data persistence** in Docker.

Folder in physical host fs is mounted to virtual fs of Docker container (or, container fs is "plugged in" to host's physical fs). Data gets automatically replicated on changes to physical fs and container fs.

## Volume Types

1. Host Volume: You decide which location on the HOST fs is mounted to which location on the CONTAINER fs:
    `docker run -v/home/mont/data:/var/lib/mysql/data`
    - specify the HOST location (`/home/mount/data`) and the CONTAINER FS location (`/var/lib/mysql/data`).

2. Anonymous Volume: Create a volume just by referencing the container FS, do not specify the host FS location (Docker automatically selects the host location):
    `docker run -v /var/lib/mysql/data`

3. Named Volume: Reference the HOST fs location by a NAME of your choosing, and specify the container FS location:
    `docker run -v <host-name>:/var/lib/mysql/data`
    - PREFER NAMED VOLUMES, ESPECIALLY FOR PRODUCTION

## Defining Volumes in Docker Compose

```yaml

version: '3'

services:
    mongodb:
    
        image: mongo

        ports:
        - 27017:27017

        volumes:
        - <host-vol-name>:/var/lib/mysql/data

volumes:
    <host-vol-name>
```