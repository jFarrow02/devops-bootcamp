# Ansible Inventory and Ad-hoc Commands

We will now connect Ansible to our remote servers. We need to **tell Ansible the
IP addresses** of the servers we have to manage. We do this with a file called
`hosts`. In Ansible, this is called **inventory**.

`hosts` is a file containing dagta about the Ansible client servers, meaning the
servers that will be managed by Ansible. The **default location** for the
`hosts` file is at `/etc/ansible/hosts`.

We need the IP addresses of all the servers we wish to connect to, as well as
**EITHER**:

- username/password
- **private** SSH key

We can specify **which private key** to use with the `ansible_ssh_private_key`
attribute. This attribute should point to the location of the **private** SSH
key for your server instance.

We also need to set the username with the `ansible_user` attribute.

## Ansible Ad-hoc Commands

**Ad-hoc** commands are a fast way to interact with the desired servers. They
are not stored for future use:

- `ansible [pattern] -m [module] -a "[module-options]"`

  - `-[pattern]`: targeting hosts and groups
  - `all` = default group, which contains every host

- `[module]` = discrete units of code in ansible

## Managing Servers on Multiple Platform

We can use Ansible syntax to **group** servers by platform, allowing us to
manage servers on **multiple platforms** (AWS, Digital Ocean, GCP, etc.) from
**one `hosts` file**. We can perform different management actions **depending on
the group**:

`hosts`

```sh
[droplet] # Designate group with square bracket syntax
134.289.255.142 ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root

134.289.235.158 ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root


[aws] # Second group here
```

### Grouping Hosts

- You can put each host in more than one group
- You can create groups that track:
  - **WHERE**: a datacenter/region
  - **WHAT**: e.g. a database server, web server, etc.
  - **WHEN**: which stage, e.g. dev, test, prod

### Executing commands

- `ansible droplet -i hosts -m ping`: Execute the `ping` command for the
  **droplet group only**

- `ansible {server-ip-address} -i hosts -m ping`: Execute the `ping` command for
  the **server ip address** only

### Creating Group Configuration

Instead of creating configurations for **each individual server** in `hosts`, we
can create a configuration for a **group**:

`hosts`

```sh
[droplet] # Create droplet group
134.289.255.142

134.289.235.158

[droplet:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root

ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root

```
