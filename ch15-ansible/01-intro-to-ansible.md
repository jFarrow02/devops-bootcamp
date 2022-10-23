# Introduction to Ansible

## What is Ansible?

**Ansible** is a tool to automate IT tasks, such as:

1. Deploying application version to multiple servers
2. Updates, back-ups, system reboots, etc.

**Ansible** makes these scenarios more efficient by:

- Allowing you to execute tasks on multiple servers from your local machine

- Configuration/installation/deployment steps in a single `yaml` file

- Re-use same file multiple times and for different environments

- More reliable and less error-prone

Ansible is **agentless**; simply SSH into target server(s) from your local
machine. No need to install agent on the target server(s).

## Ansible Architecture

Ansible works with **modules**, small programs that do the work. Modules get
pushed to the target server, do their work, and then get removed. Modules are
granular, i.e. they do one small, specific task. Ansible has hundreds of modules
that each execute a specific task.

Ansible uses `yaml`, which means it is intuitive and doesn't require learning a
new language.

To create a complex configuration, you will group multiple modules in a certain
sequence, using **Ansible Playbooks**.

The **hosts** and **remote_user** attributes define where the tasks should
execute, and which user will execute the task(s).

**Variables** allow you to re-use values.

A **Play** is a block that define which tasks should executed on which host, by
which user. It is good practice to **name your plays** in a playbook.

An **Inventory** defines all the machines involved in executing a play.

### Ansible Tower

A UI dashboard from Red Hat that gives you a way to centrally store automation
tasks across teams, configure permissions, etc.

## Alternatives to Ansible

Puppet and Chef are alternatives to Ansible. They use Ruby instead of YAML.
Puppet and Chef must be **installed and managed** on each target system/server.
