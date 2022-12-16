# Deploy Node App: Part 2

## Start Node App

To run our node app we need to:

- Install `package.json` dependencies
- Run `node` command and execute server file

`deploy-node.yaml`:

```yaml
# ...

- name: Deploy nodejs app
  hosts: 000.000.000.000
  tasks:
    - name: Copy nodejs folder to a server
      copy:
        src: /path/to/tarfile/file-name.tgz
        dest: /root/target-file-name.tgz

    - name: unpack the nodejs tar file
      unarchive:
        src: /root/target-file-name.tgz
        dest: /root/
        remote_src: yes
    - name: Install dependencies
        community.general.npm:
            path: /root/package # path to package.json on REMOTE server
    - name: Start the application
        ansible.builtin.command:
            chdir: /root/package # path to node/express server file on REMOTE server

            cmd: node server.js
```

[Search the Ansible docs](https://docs.ansible.com/ansible/latest/collections)
for "node js" and you should find the
[`community.general.npm` module](https://docs.ansible.com/ansible/latest/collections/community/general/npm_module.html).
This module allows you to **manage node.js packages with `npm`** from Ansible.

At this point, the server should be **running**. To verify, SSH into your
instance and run `ps aux | grep node`. You should see output similar to the
following:

```
root@ansible-nodeapp-server:~# ps aux | grep node
root        8766  0.1  2.5 611904 50656 pts/1    Sl+  14:22   0:00 node index.js
root        8783  0.0  0.1   6852  2096 pts/0    S+   14:27   0:00 grep --color=auto node

```

Note however that the Ansible process in your terminal is **hanging**. This is
because the `node server` command is blocking the terminal. We need to run it in
the **background** by adding the `async` and `poll` attributes. These allow us
to run any task **asynchronously**:

```yaml
# ...
- name: Start the application
        ansible.builtin.command:
            chdir: /root/package # path to node/express server file on REMOTE server

            cmd: node server.js
        async: 1000 # timeout of 1000 seconds
        poll: 0 # start task and immediately move on to next task
```

## Ensure App is Running

To make sure the app is running **without** running `ps aux` on the server, we
can use the **shell** module. **shell** is similar to **command**, except that
it executes commands in the shell, with access to shell operators, environment
variables, etc.

### Why Use `command` At All? Why Not Just Use `shell`?

`command` is more secure. The `shell` module is vulnerable to shell injection.
Use `shell` only when you need access to the shell operators, env vars etc.

### Return Values of Modules

Ansible modules normally return data. That data can be **registered into a
variable**. The `register` attribute is available for any task/module, and
creates a variable and assigns it the result of the task/module execution.

```yaml
# ...
- name: Start the application
        ansible.builtin.command:
            chdir: /root/package
            cmd: node server.js
        async: 1000
        poll: 0
- name: Ensure app is running
  shell: ps aux | grep node
  register: app_status # create app_status variable
- debug: msg={{app_status}} # reference app_status variable with {{}} syntax

```

You should see output similar to the following:

```
ok: [147.182.132.224] => {
    "msg": {
        "changed": true,
        "cmd": "ps aux | grep node",
        "delta": "0:00:00.013540",
        "end": "2022-12-16 14:43:34.538966",
        "failed": false,
        "msg": "",
        "rc": 0,
        "start": "2022-12-16 14:43:34.525426",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "root        9150  0.0  2.5 611628 50760 ?        Sl   14:33   0:00 node index.js\nroot        9878  0.0  0.0   2736   964 pts/1    S+   14:43   0:00 /bin/sh -c ps aux | grep node\nroot        9880  0.0  0.1   6852  2132 pts/1    S+   14:43   0:00 grep node",
        "stdout_lines": [
            "root        9150  0.0  2.5 611628 50760 ?        Sl   14:33   0:00 node index.js",
            "root        9878  0.0  0.0   2736   964 pts/1    S+   14:43   0:00 /bin/sh -c ps aux | grep node",
            "root        9880  0.0  0.1   6852  2132 pts/1    S+   14:43   0:00 grep node"
        ]
    }
}

```
