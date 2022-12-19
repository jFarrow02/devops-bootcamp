# Run Docker Applications in Ansible: Part 1

## Overview

In this project, we'll write an Ansible playbook toinstall Docker and
docker-compose on an EC2 instatnce. We will star Docker containers and run an
application.

This configuration will be **different**, because it is an **Amazon EC2**
instance with the **Amazon Linux OS**.

Steps:

1. Create an EC2 instance with Terraform
2. Configure inventory file to connect to AWS EC2
3. Write plays that install Docker and docker-compose
4. Copy docker-compose file to server
5. Start Docker containers

## Create EC2 Instance with Terraform

See the **automate-ec2** (lessons 12 - 14) sections of chapter 12 for reminders
on how to provision an EC2 instance and VPC in AWS with Terraform. **NOTE**: you
will want to **remove** the user data from the Terraform script, as we will be
**installing Docker and docker-compose with Ansible**.

## Adjust Inventory File

`hosts`:

```
[docker_server]
000.000.000.000
ansible_ssh_private_key_file={private-key-file-location}
ansible_user=ec2=user

```

## Create Playbook

`deploy-docker.yaml`

```yaml
---
- name: Install Python3
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install Python3
      vars:
        ansible_python_interpreter: /usr/bin/python # install python 3 using the python 2 interpreter as python3 is not available yet
      yum:
        name: python3
        update_cache: yes
        state: present

- name: Install Docker
  hosts: docker_server
  become: yes
  become_user: root # Switch to root user in order to install packages
  tasks:
    - name: Install Docker
        vars:
            ansible_python_interpreter: /usr/bin/python # Switch to python 2 for yum tasks
        yum: # Note that we use the yum module, as the Amazon Linux instance OS uses yum as its package manager
            name: docker
            update_cache: yes
            state: present

- name: Install docker-compose
  hosts: docker_server
  become: yes
  become_user: root
  tasks:
    - name: Install docker-compose
      get_url:
        url: https://github.com/docker/compose/releases/download/v2.14.0/docker-compose-Linux-{{lookup('pipe', 'uname -m')}} # 'pipe' is an ansible lookup plugin. It calculates the output of the shell command and pipes it to the left side of your lookup.
        dest: /usr/local/bin/docker-compose
        mode: +x

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
      meta: reset_connection # re-connect immediately after adding user to docker group, so group addition takes effect right away

- name: Test docker pull
  host: docker_server
  tasks:
    - name: Pull redis
      command: docker pull redis
```

[Docker-compose installation docs](https://docs.docker.com/compose/install/)

### Configure Ansible to use Python3 interpreter

`hosts`:

```
[defaults]
# ...

interpreter_python = /usr/bin/python3
```
