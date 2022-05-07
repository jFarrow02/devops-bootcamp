# Docker Architecture & Components

## Docker Engine
3 parts to Docker Engine:
1. Server: pulls images, stores images, starts/stops containers
    - Container runtime: pulls images, manages container lifecycle
    - Volumes: persist data
    - Network: configures network for container communication
    - Build images: build own Docker images
2. API: Interacts with server
3. CLI: Client for interacting with server

**Note:** Docker is supported **natively** on Linux. For Mac and Windows you must install **Docker Desktop**.