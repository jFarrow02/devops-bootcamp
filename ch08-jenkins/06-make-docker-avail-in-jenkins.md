# Making Docker Available in Jenkins

In most scenarios, you will want to build Docker images of your applications in Jenkins (to push to artifact repos). To do so, Docker commands must be available in Jenkins.

The most common way to do this is to:

- Mount Docker runtime directory **from** instance **to** container as a volume. This will make Docker commands available inside Jenkins container.

- Must **stop** the currently-running Jenkins container (if applicable), **mount the new volume and the current volume (with the saved data/configuration for Jenkins) from server host**, and start a new container.

## Stopping Container and Attaching New Volume

1. `docker ps` (Get running container ID)
2. `docker stop {container_id}`
3. 
```
    docker run -p 8080:8080 -p 50000:50000 -d \
    -v jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    jenkins/jenkins
```
    - jenkins_home: Original value containing Jenkins jobs, etc.
    - /var/run/docker.sock: Docker volume
    - $(which docker): Docker runtime binary
4. Change permissions on /var/run/docker.sock to allow jenkins Linux user to read/write:
    - `docker exec -u 0 -it {container_id} /bin/bash`
    - `chmod o=rw- /var/run/docker.sock`

**You can now execute Docker from "Execute Shell" commands in any Jenkins build.**


## Build Docker image in Jenkins

1. Dashboard > {project name} > Configure > Build > Execute Shell
2. Command > "docker build <dockerfile-dir> -t <image-name>:<tag>"
3. Docker image of your app is now available in container:
    - `docker image ls`

## Push to Private Docker Repository
 
1. Add repository credentials to Jenkins:
    - Jenkins > Credentials > System > Global credentials (unrestricted) > Add credentials
2. Add binding for private Docker repository credentials to job:
    - Build Environment > Bindings > Username & password (separated)
    - Attach binding name to selected credentials

3. Update image name to push to repository:
    - Jenkins > {job name}

    ```
    docker build -t {repo-name}/{application-name}:{tag}
    echo $PASSWORD | docker login -u ${username-var} --password-stdin // for security reasons, do not expose password 
    {repo-host-if-not-dockerhub}
    docker push {image-name}:{tag}
    ```

4. Push to Nexus Repository

    - Add to insecure registries file on **server host (NOT in container)**
        `touch /etc/docker/daemon.json`

        `daemon.json`:

        ```
            {
                "insecure-registries": [ "{nexus-host-ip}:8083" ]
            }
        ```
    
    - Restart Docker to apply system changes:
        ```
           sudo systemctl restart docker

           docker start {container-id}

        ```

    - Reconfigure permissions to /var/run/docker.sock **inside container** file to restore read/write permissions to non-users/non-owners (this was overwritten when you restarted Docker)

    ```
        docker exec -u 0 -it {container-id} /bin/bash
        chmod o=rw /var/run/docker.sock
    ```

    - Create Nexus credentials in Jenkins

        - Jenkins > Credentials > System > Global Credentials
        - Add new username/password credentials for Nexus user with permissions to the Docker hosted repo where you want to push your built images

    - Modify Docker image name in Jenkins script to reflect Nexus repository
        ```
            docker build -t {nexus-repo-url}:{nexus-repo-port}/{application-name}:{tag}
            echo $PASSWORD | docker login -u ${username-var} --password-stdin
            {nexus-repo-host}:{nexus-repo-port}
            docker push {nexus-repo-url}:{nexus-repo-port}/{application-name}:{tag}
        ```
