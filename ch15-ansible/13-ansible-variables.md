# Ansible Variables

## Registered Variables

**Registered variables** are variables that we create from the **output of an
Ansible task**. They can be used in any later tasks in your play. We saw an
example in the `Ensure app is running` task with the `app_status` variable.

## Parameterize Playbook

What if we want to **parameterize** some values in our Ansible playbook, to make
them **configurable**?

### Setting Parameter Values in a Playbook

There are multiple ways to set parameter values in an Ansible playbook:

#### Using the `vars` Attribute

We can set variable values in a playbook with the `vars` attribute:

```yaml
# ...
- name: Deploy nodejs app
  hosts: 000.000.000.000
  become: True
  become_user: nodejs-user
  vars:
    - location: /path/to/tarfile
    - version: 1.0.0
    - destination: /path/to/destination
```

#### Passing as Arguments from Command Line

We can make parameters **configurable** from **outside the playbook** by passing
them at runtime from the `ansible-playbook` command:

- `ansible-playbook -i -e "version=1.0.0" location="/path/to/tarfile" {host-file-location} {playbook-file-location}`:
  Pass the `location` variable to the playbook on execution

`deployment.yaml`

```yaml
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

- name: Create new linux user for node app
    hosts: 000.000.000.000
    tasks:
    - name: Create linux user
      ansible.builtin.user:
        name: "{{linux_name}}"
        comment: Linux user for nodejs app
        group: admin

- name: Deploy nodejs app
  hosts: 000.000.000.000
  become: True
  become_user: "{{linux_name}}"
  vars:
    - destination: /home/{{linux_name}}

  tasks:
    - name: Copy nodejs folder to a server
      copy:
        src: /path/to/tarfile/file-name.tgz
        dest: "{{user_home_dir}}/target-file-name.tgz"

    - name: unpack the nodejs tar file
      unarchive:
        src: "{{location}}/nodejs-app-{{version}}.tgz" # Enclose in double quotes to distinguish variables from dictionaries AFTER ":"
        dest: "{{user_home_dir}}"
        remote_src: yes
    - name: Install dependencies
        community.general.npm:
            path: "{{user_home_dir}}/package"
    - name: Start the application
        ansible.builtin.command:
            chdir: "{{user_home_dir}}/package"
            cmd: node server.js
        async: 1000
        poll: 0
    - name: Ensure app is running
      shell: ps aux | grep node
      register: app_status # Reference Variable
    - debug: msg={{app_status}}
```

#### Using an External Variables File

A more convenient way to set variables from outside is to use a **variables
file**:

1. Create a new file in your Ansible project root (file name is arbitrary):

`project-vars.yaml`:

```yaml
version: 1.0.0
location: /path/to/local/nodejs/app
linux_name: nodejs-user
user_home_dir: /home/{{linux_name}}
```

2. Use the `vars_files` attribute:

`deployment.yaml`

```yaml
# ...

- name: Deploy nodejs app
  hosts: 000.000.000.000
  become: True
  become_user: '{{linux_name}}'
  vars_files:
    - project-vars
```

**Note that you will need to set `vars_files` for EVERY TASK in which you use
variables in the playbook**.

3. Execute `ansible-playbook` command

### Variable Naming Conventions

- Python keywords, such as `async`, and playbook keywords, such as
  `environment`, are **invalid**

- Letters, numbers, and underscores are **valid**

- Variable names must start with a **letter**
