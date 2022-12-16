# Deploy Node Application: Part 3

## Executing Tasks with a Different User

So far, we're executing all our tasks as the **root** user. As we've learned,
this is a **bad security practice**. We should be creating **new users for each
app or team member**.

To do this, we'll need to:

1. Create a new user
2. Run the app using the new user

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
        name: nodejs-user
        comment: Linux user for nodejs app
        group: admin

- name: Deploy nodejs app
  hosts: 000.000.000.000
  become: True
  become_user: nodejs-user # Switch to nodejs-user

  tasks:
    - name: Copy nodejs folder to a server
      copy:
        src: /path/to/tarfile/file-name.tgz
        dest: /home/nodejs-user/target-file-name.tgz # Change all paths from /root to /home/nodejs-user

    - name: unpack the nodejs tar file
      unarchive:
        src: /home/nodejs-user/target-file-name.tgz
        dest: /home/nodejs-user/
        remote_src: yes
    - name: Install dependencies
        community.general.npm:
            path: /home/nodejs-user/package
    - name: Start the application
        ansible.builtin.command:
            chdir: /home/nodejs-user/package
            cmd: node server.js
        async: 1000
        poll: 0
    - name: Ensure app is running
      shell: ps aux | grep node
      register: app_status
    - debug: msg={{app_status}}
```
