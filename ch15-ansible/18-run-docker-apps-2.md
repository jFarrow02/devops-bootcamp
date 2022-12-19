# Run Docker Applications: Part 2

## User `community.docker` Ansible Collection

The **Docker Community Collection** includes many modules and plugins to work
with Docker.

You should use the `command` and `shell` modules **only when there is no
appropriate Ansible module available**, because they don't have state
management.

## Pull Docker Image

`deploy-docker.yaml`

```yaml
# ... Install docker-python module on EC2 instance to allow it to execute the "Test docker pull" play
- name: Install Docker python module
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install Docker python module
        pip:
          name:
            - docker
            - docker-compose
# ...

- name: Test docker pull
  host: docker_server
  tasks:
    - name: Pull redis
      community.docker.docker_image: # Use FULLY-QUALIFIED package names!
        name: redis
        source: pull

# Login to Docker if docker-compose contains image(s) in PRIVATE repo
- name: Login to Docker
  host: docker_server
  vars_prompt:
    - name: docker_password
      prompt: Enter password for docker registry
  tasks:
    - name: Docker login
      registry_url: https://index.docker.io/v1/
      username: your-username
      password: "{{password}}" # Parameterize password to avoid sensitive info in code repos

- name: Start docker containers
  hosts: docker_server
  tasks:
    - name: Copy docker compose # Copy docker-compose file from local machine to managed server
      copy:
        src: /path/to/file/filename
        dest: /home/ec2-user/filename.yaml # path to user's home dir

    - name: Start container from compose
      docker_compose:
        project_src: /home/ec2-user
        state: present # equivalent to docker-compose up
```

## `deploy-docker.yaml` Final State

`deploy-docker.yaml`

```yaml
---
- name: Install Python3
  hosts: docker_server
  become: yes
  gather_facts: False
  become_user: root
  tasks:
    - name: Install Python3
      vars:
        ansible_python_interpreter: /usr/bin/python
      yum:
        name: python3
        update_cache: yes
        state: present

- name: Install Docker
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install Docker
        vars:
            ansible_python_interpreter: /usr/bin/python
        yum:
            name: docker
            update_cache: yes
            state: present

- name: Install Docker python module
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install Docker python module
        pip:
          name:
            - docker
            - docker-compose

- name: Install docker-compose
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install docker-compose
      get_url:
        url: https://github.com/docker/compose/releases/download/v2.14.0/docker-compose-Linux-{{lookup('pipe', 'uname -m')}}
        dest: /usr/local/bin/docker-compose
        mode: +x

# - name: Login to Docker
#   host: docker_server
#   vars_prompt:
#     - name: docker_password
#       prompt: Enter password for docker registry
#   tasks:
#     - name: Docker login
#       registry_url: https://index.docker.io/v1/
#       username: your-username
#       password: "{{docker_password}}"

- name: Login to Docker
  host: docker_server
  vars_files:
    - project-vars
  tasks:
    - name: Docker login
        registry_url: https://index.docker.io/v1/
        username: your-username
        password: "{{docker_password}}"

- name: Start docker
  hosts: docker_server
  become: yes
  tasks:
    - name: start docker daemon
      systemd:
        name: docker
        state: started

- name: Add ec2-uer to docker group
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Add ec2-user to docker group
      user:
        name: ec2-user
        groups: docker
        append: yes
    - name: Reconnect to server session
      meta: reset_connection

- name: Test docker pull
  host: docker_server
  tasks:
    - name: Pull redis
      community.docker.docker_image: # Use FULLY-QUALIFIED package names!
        name: redis
        source: pull

- name: Login to Docker
  host: docker_server
  vars_prompt:
    - name: docker_password
      prompt: Enter password for docker registry
  tasks:
    - name: Docker login
      registry_url: https://index.docker.io/v1/
      username: your-username
      password: "{{password}}"

- name: Start docker containers
  hosts: docker_server
  tasks:
    - name: Copy docker compose
      copy:
        src: /path/to/file/filename
        dest: /home/ec2-user/filename.yaml

    - name: Start container from compose
      docker_compose:
        project_src: /home/ec2-user
        state: present
```

`project-vars`:

```
docker_password: your-password-here
```

## Making the Playbook More Generic

Our playbook works well for EC2 using Amazon Linux, but what about other
servers/distributions?

Best practice is to create playbooks that are **resuable** and work with
**multiple servers/distros**.

Instead of using `ec2-user`, we'll create a new user and use that user to
execute our tasks.

Create a new file: `deploy-docker-newuser.yaml`

`deploy-docker-newuser.yaml`:

```yaml
---
- name: Install Python3
  hosts: docker_server
  become: yes
  gather_facts: False
  become_user: root
  tasks:
    - name: Install Python3
      vars:
        ansible_python_interpreter: /usr/bin/python
      yum:
        name: python3
        update_cache: yes
        state: present

- name: Install Docker
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install Docker
        vars:
            ansible_python_interpreter: /usr/bin/python
        yum:
            name: docker
            update_cache: yes
            state: present

- name: Install Docker python module
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install Docker python module
        pip:
          name:
            - docker
            - docker-compose

- name: Install docker-compose
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install docker-compose
      get_url:
        url: https://github.com/docker/compose/releases/download/v2.14.0/docker-compose-Linux-{{lookup('pipe', 'uname -m')}}
        dest: /usr/local/bin/docker-compose
        mode: +x

- name: Login to Docker
  host: docker_server
  vars_files:
    - project-vars
  tasks:
    - name: Docker login
        registry_url: https://index.docker.io/v1/
        username: your-username
        password: "{{docker_password}}"

- name: Start docker
  hosts: docker_server
  become: yes
  tasks:
    - name: start docker daemon
      systemd:
        name: docker
        state: started

- name: Create new linux user # Create new user
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Create new linux user
      user:
        name: newuser
        groups: adm, docker

- name: Login to Docker
  host: docker_server
  become: yes
  become_user: newuser
  vars_prompt:
    - name: docker_password
      prompt: Enter password for docker registry
  tasks:
    - name: Docker login
      registry_url: https://index.docker.io/v1/
      username: your-username
      password: "{{password}}"

- name: Start docker containers
  hosts: docker_server
  become: yes
  become_user: newuser
  tasks:
    - name: Copy docker compose
      copy:
        src: /path/to/file/filename
        dest: /home/newuser/filename.yaml

    - name: Start container from compose
      community.docker.docker_compose:
        project_src: /home/newuser
        state: present
```
