# Deploy Node App: Part 1

## Project Introduction

In this project we will automate installing a Nodejs app on a Digital Ocean
server:

1. Create a Droplet
2. Write Ansible Playbook
3. Install node & npm
4. Copy node artifact and unpack
5. Start application and verify that it is running successfully

### Create Droplet

Create Digital Ocean droplet per Chapter 5 lecture 2.

### Write Ansible Playbook

`hosts`:

```
000.000.000.000 ansible_ssh_private_key_file={ssh-private-key-location}
ansible_user=root
```

### Install node and npm

Create a new playbook for installing `node` and `npm`. First we will install all
the app dependencies via `npm` and then run the application using `node`
command:

`deploy-node.yaml`:

```yaml
---
- name: Install node and npm
  hosts: 000.000.000.000
  tasks:
    - name: Update apt repo and cache
      apt: update_cache=yes force_apt_get=yes cache_valid_time=3600
    - name: install nodejs and npm
      apt:
        pkg:
          - nodejs
          - npm

- name: Deploy nodejs app
  hosts: 000.000.000.000
  tasks:
    - name: Copy nodejs folder to a server
      copy:
        src: /path/to/tarfile/file-name.tgz
        dest: /root/target-file-name.tgz # Note that this will be the home directory of whatever user you configured as "ansible_user" in hosts file

    - name: unpack the nodejs tar file
      unarchive:
        src: /root/target-file-name.tgz
        dest: /root/
        remote_src: yes
```

- `ansible-playbook -i hosts deploy-node.yaml`
