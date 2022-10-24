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

SSH into server(s) and confirm that nginx is running:

- `ps aux | grep nginx`

### Install a Specific Version

To provide a specific version of a package, set the version next to the package
and change the `state` value to `present`:

`my-playbook.yaml`

```yaml
---
- name: Config nginx webserver
  hosts: webserver
  tasks:
    - name: install nginx server
      apt:
        name: nginx=1.18.0-0ubuntu1
        state: present
    - name: start nginx server
      service:
        name: nginx
        state: started
```

### Ansible Idempotency

**Most** Ansible modules check whether the desired state has already been
achieved. If so, they exit without performing any actions.

## Stop Created Server

`my-playbook.yaml`

```yaml
---
- name: Config nginx webserver
  hosts: webserver
  tasks:
    - name: uninstall nginx server
      apt:
        name: nginx=1.18.0-0ubuntu1
        state: absent
    - name: stop nginx server
      service:
        name: nginx
        state: stopped
```
