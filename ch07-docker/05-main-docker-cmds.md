# Main Docker Commands

## docker pull
- `docker pull <image-name>:<tag>`: pulls image from Dockerhub repository. Not specifiying `tag` pulls the latest image by default.

## docker run
- `docker run <image-name>`: runs container from image `image-name`.
    - `docker run -d <image-name>`: runs container in "detached" mode.
    - `docker run -d -p<host-port>:<container-port> <image-name>`: runs in detached mode and binds `container-port` to `host-port` on host machine. `host-port` must not be in use by another process.
    - `docker run -d -p<host-port>:<container-port> --name <any-name> <image-name>`: run a container and specify container name

## docker stop
- `docker stop <container>`: stops container. `container` can be container name or container id.

## docker start
- `docker start <container>`: restarts a stopped container.

## docker ps
- `docker ps`: list running containers
- `docker ps -a`: list all containers