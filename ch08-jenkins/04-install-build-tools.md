# Intro to Jenkins/Install Build Tools

2 Roles for Jenkins App:

1. Administrator:

   - Manages Jenkins
   - sets up Jenkins cluster
   - installs plugins
   - backup

2. Users:
   - DevOps or DevOps team
   - Create jobs to automate workflow, setup CI/CD pipeline etc.

For Admins: - Manage Jenkins section

## Install Build Tools

Must install and configure your build tools on Jenkins in order to have those
commands available to your Jenkins jobs.

2 ways to install build tools:

1. As a **plugin**
2. Instal directly on the **server**

### Configure Maven Plugin on Jenkins

1. Manage Jenkins > Global Tools Configuration > Maven
   - Select configuration name > Select Maven version > Install from Apache

### Install NPM on the Jenkins Container

1. Enter Jenkins container as **root user** in order to get install privileges:
   `docker exec -it -u 0 {container-name} /bin/bash` `cat /etc/issue` # Check
   your Linux distro to find out which distro of node you need to install
   `apt install curl`

```
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs
```
