# Deploy Nexus: Part 1

## Introduction

In this hands-on project, we will automate deploying **Nexus** on a remote
server using Ansible. Previously we did this **manually**; we will now
**automate** this process so that we can execute it repeatedly on **any number
of servers**!

After we complete this, you should be able to **translate these skills** to
create playbooks for automating **any application** with Ansible.

## Preparation

1. Create a new Digital Ocean droplet (or any cloud provider instance).

2. Create a new playbook, `deploy-nexus.yaml` with the following content:

```yaml
---
- name: Install java and net-tools
  hosts: digitalocean
  tasks:
    - name: Update apt repo and cache
      apt:
        update_cache: yes
        force_apt_get: yes
        cache_valid_time: 3600
    - name: Install Java 8
      apt: name=openjdk-8-jre-headless
    - name: Install net-tools
      apt: name=net-tools

- name: Download and unpack Nexus installer
  hosts: digitalocean
  tasks:
    - name: Download nexus
      get_url:
        url: https://download.sonatype.com/nexus/3/latest-unix.tar.gz
        dest: /opt/
      register: download_result # register the return value of the "Download nexus" task in a variable for use in the next module
    - debug: msg={{download_result}}

    - name: Find nexus directory
      find:
        paths: /opt
        pattern: 'nexus-*'
        file_type: directory
      register: find_result
    - debug: msg={{find_result}}

    - name: Check if nexus folder already exists
      stat:
        path: /opt/nexus
      register: stat_result
    - debug: msg={{stat_result}}

    - name: Rename nexus directory
      shell: mv {{find_result.files[0].path}} /opt/nexus
      when: not stat_result.stat.exists # Ansible conditional; execute tasks IF a certain condition is true

    - name: untar nexus
      unarchive:
        src: '{{find_result.dest}}' # Use the     "dest" attribute of "download_result" as    the DYNAMIC source location
        dest: /opt/
        remote_src: True
```
