# Intro to Ansible Playbooks

With Ansible, we want to do useful things on servers (configure them, install
applications, update server, create files etc.). For that, we write **Ansible
Playbooks**. These playbooks are stored with the source code per
Infrastructure-as-Code principles.

There are **2 minimum required files** in an Ansible Playbook:

- `hosts`: Contains the managed nodes to target
- `{playbook-name}.yaml`: Contains at least one task to execute. A playbook can
  have multiple "plays" (tasks).

## Create Playbook

`my-playbook.yaml`

```yaml
---
- name: Config nginx webserver
  hosts: webserver
  tasks:
    - name: install nginx server
      apt:
        name: nginx
        state: latest
    - name: start nginx server
      service:
        name: nginx
        state: started
```

## Execute Playbook

- `anisble-playbook -i {hosts-file} {playbook-name}.yaml`
