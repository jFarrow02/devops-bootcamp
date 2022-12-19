# Default Inventory File

## Configure Git

Initialize a `git` repository in your `deploy-nexus` project. We will want to
store our Ansible files in **source code management**, just as we do with our
application source code.

## Configure Inventory Default Location

We will also configure our **default hosts file**. Until now, we have passed our
`hosts` file to the `ansible-playbook` command. We can configure the **default**
location of the hosts file in `ansible.cfg`:

`ansible.cfg`

```
[defaults]
host_key_checking = False
inventory = {{hosts-file-location}}
```

We can now run `ansible-playbook` **without** the `hosts` parameter:

- `ansible-playbook {playbook-location.yaml}`
