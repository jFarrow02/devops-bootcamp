# Deploy Nexus: Part 2

## Create `nexus` User and `chown`

Add the following task to the `deploy-nexus.yaml` file to create the `nexus`
user and `nexus` group:

```yaml
# ...

- name: Create nexus user to own nexus folders
    hosts: digitalocean
    tasks:
        - name: Ensure group nexus exists
          group:
            name: nexus
            state: present
        - name: Create nexus user
          user:
            name: nexus
            group: nexus
        - name: Make nexus user owner of nexus folder
          file:
            path: /opt/nexus
            state: directory
            owner: nexus
            group: nexus
            recurse: yes
        - name: Make nexus user owner of sonatype-work folder
          file:
            path: /opt/sonatype-work
            state: directory
            owner: nexus
            group: nexus
            recurse: yes
```

## Update `nexus.rc` File and Start Nexus

```yaml
# ...

- name: Start nexus with nexus user
  hosts: digitalocean
  become: True
  become_user: nexus
  tasks:
    - name: Set run_as_user nexus
        blockinfile: # the "blockinfile" module allows us to add multiple lines to a file
            path: /opt/nexus/bin/nexus.rc
            block: |
                run_as_user="nexus"
    - name: Start nexus
      ansible.builtin.command: /opt/nexus/bin/nexus start
```

Note that you can also use the `lineinfile` module when replacing a **single
line**:

```yaml
- name: Start nexus with nexus user
  hosts: digitalocean
  tasks:
    - name: Set run_as_user nexus
        lineinfile:
            path: /opt/nexus/bin/nexus.rc
            regexp: '^#run_as_user=""'
            line: run_as_user="nexus"

```

## Ensure Nexus is Running

```yaml
- name: Verify nexus is running
  hosts: digitalocean
  tasks:
    - name: Check with ps
      shell: ps aux | grep nexus
      register: app_status
    - debug: msg={{app_status.stdout_lines}}

    - name: Wait one minute # Wait intil nexus is running before attempting netstat
        pause:
            minutes: 1

    - name: Check with netstat
      shell: netstat -lnpt
      register: app_status
    - debug: msg={{app_status.stdout_lines}}
```

## End `deploy-nexus.yaml` State

`deploy-nexus.yaml`:

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
  - name: Check if nexus folder already exists
      stat:
        path: /opt/nexus
      register: stat_result
    - debug: msg={{stat_result}}

    - name: Download nexus
      get_url:
        url: https://download.sonatype.com/nexus/3/latest-unix.tar.gz
        dest: /opt/
      register: download_result
    - debug: msg={{download_result}}

    - name: Find nexus directory
      find:
        paths: /opt
        pattern: 'nexus-*'
        file_type: directory
      register: find_result
    - debug: msg={{find_result}}

    - name: Rename nexus directory
      shell: mv {{find_result.files[0].path}} /opt/nexus
      when: not stat_result.stat.exists

    - name: untar nexus
      unarchive:
        src: '{{find_result.dest}}'
        dest: /opt/
        remote_src: True
      when: not stat_result.stat.exists


- name: Create nexus user to own nexus folders
    hosts: digitalocean
    tasks:
        - name: Ensure group nexus exists
          group:
            name: nexus
            state: present
        - name: Create nexus user
          user:
            name: nexus
            group: nexus
        - name: Make nexus user owner of nexus folder
          file:
            path: /opt/nexus
            state: directory
            owner: nexus
            group: nexus
            recurse: yes
        - name: Make nexus user owner of sonatype-work folder
          file:
            path: /opt/sonatype-work
            state: directory
            owner: nexus
            group: nexus
            recurse: yes

- name: Start nexus with nexus user
  hosts: digitalocean
  tasks:
    - name: Set run_as_user nexus
        blockinfile:
            path: /opt/nexus/bin/nexus.rc
            block: |
                run_as_user="nexus"

- name: Verify nexus is running
  hosts: digitalocean
  tasks:
    - name: Check with ps
      shell: ps aux | grep nexus
      register: app_status
    - debug: msg={{app_status.stdout_lines}}

    - name: Wait one minute
        pause:
            minutes: 1

    - name: Check with netstat
      shell: netstat -lnpt
      register: app_status
    - debug: msg={{app_status.stdout_lines}}
```
