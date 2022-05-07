# Install and Run Nexus on a Cloud Server

## Server Requirements

1. At least 4GB of memory; 8GB is better.
2. Firewall rules:
    - SSH on port 22
    - Custom TCP on port 8083 (all IP addrs)
    - Custom TCP on port 8081 (all IP addrs) to access nexus app in browser

3. Install Nexus:

```
sudo apt update

sudo apt install net-tools

sudo apt install openjdk-8-jre-headless

cd /opt

wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz

sudo tar -zvxf latest-unix.tar.gz

adduser <username>
# add user password and credentials...

rm -r latest-unix.tar.gz

sudo chown -R <username>:<usergroup> <nexus dir>
sudo chown -R <username>:<usergroup> sonatype-work

# change user to nexus-user in <nexus dir>/bin/nexus.rc

su <nexus_user>

cd nexus-3.##.#-##/bin

nano nexus.rc

# run_as_user="<nexus_user>"

#

./nexus start

Open <nexusserver_ip>:8081 in browser
```

## Nexus UI

1. Find the admin password needed for logging in to Nexus UI initially at `/opt/sonatype-work/nexus3/admin.password`.

2. "Sign In" > enter admin username ("admin") and password from step 1.

3. Change admin password and confirm change.

4. Select "Enable/Disable anonymous access". 
    - Enable anonymous access means that by default, users can search, browse and download components from repositories without credentials. Please consider the security implications for your organization.

    - Disable anonymous access should be chosen with care, as it will require credentials for all users and/or build tools.

## Repositories

### Repository Types
1. Proxy: Linked to a remote repository (e.g. Maven). If a component is requested from the remote repo, the request will go thru proxy first and check whether the package is available in Nexus. If YES, the dependency will be downloaded from Nexus. If NO, dependency will be downloaded and cached in Nexus FIRST.
    - Single endpoint for all package downloads

2. Hosted: Primary storage for company-owned artifacts
    - Snapshots: Artifacts to be TESTED before release
    - Releases: Production-ready artifacts

3. Group: Allows you to group multiple individual repositories behind a SINGLE endpoint.
    - Single URL, access to multiple repos