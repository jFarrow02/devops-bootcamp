# Install Ansible

There are 2 locations where we can install Ansible:

- **Locally** on your local machine, or

- On a **remote** server

Using Ansible will work the same no matter where you install it.

## Installing Ansible

Ansible is written in **Python**. The officially-supported method of installing
Ansible is with `pip`,
[as described in the Ansible documentation.](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

- `python3 -m pip install --user ansible`

### Confirming Installation

- `ansible --version`
