# Terraform and Ansible

## Integrate Ansible Playbook Execution in Terraform

We can now **provision the server infrastructure** with **Terraform**, and
**configure the server** with **Ansible**. How do we link the two **in a
completely automated way**?

We can configure the handover from Terraform to Ansible **inside the Terraform
config file**, by using **Terraform provisioners**.

`main.tf`:

```sh
# ...
resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.amazon-linux-image.id
    instance_type = var.instance_type
    key_name = "myapp-key"
    associate_public_ip_address = true
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    tags = {
        Name = "server-name"
    }

    # The "local_exec" provisioner invokes a local executable after a resource is created.
    # Is invoked on the machine running TF,
    # NOT on the resource!
    # The Ansible command we'll execute runs on our
    # local machine, hence we'll use local_exec

    provisioner "local_exec" {
        working_dir = "/path/to/ansible/project-dir"
        command = "ansible-playbook --inventory $ {self.public_ip}, --private-key ${var.ssh_key_private} --user ec2-user playbook-name.yaml"
    }

}
```

**NOTES**:

- The `--inventory` flag allows you to **override** the `hosts` file in Ansible.
  It takes either a **file location** or a **comma-separated list of IP
  addresses**. Note that you **must** follow the IP address list with a
  **comma**, **even if you include only one IP address**.

- Don't forget to define the parameterized `var.ssh_key_private` variable in
  Terraform!

- (Optional): Parameterize the username passed to the `--user` flag also

- Change the value of `hosts` parameters inside your Ansible playbook to `all`.

## Executing Terraform with Ansible Configuration

- `terraform apply -f {terraform-file-location}`: Execute as normal.

SSH into your EC2 instance(s). Run `docker ps` to verify that your containers
are running as expected.

## Ensure EC2 is Available Before Executing Ansible Playbook

It's possible that the process of provisioning the EC2 instance(s) may **not be
complete** before the provisioner we created begins to execute. We can adjust
our playbook to ensure that Ansible waits until the server(s) are available
before beginning to configure them:

```yaml
---
- name: Wait for ssh connection
  hosts: all
  gather_facts: False
  tasks:
    - name: Ensure ssh port open
      ansible.builtin.wait_for:
        port: 22
        delay: 10
        timeout: 100
        search_regex: OpenSSH
        host:
          '{{
          (ansible_ssh_host|default(ansible_host))|default(inventory_hostname)
          }}'
      vars:
        ansible_connection: local
        ansible_python_interpreter: /usr/bin/python

- name: Install Python3
  hosts: all
  become: yes
  gather_facts: False
  become_user: root
  tasks:
    - name: Install Python3
      vars:
        ansible_python_interpreter: /usr/bin/python
      yum:
        name: python3
        update_cache: yes
        state: present
# ...
```

## Using `null_resource`

Another way to execute a provisioner if we want to separate it from the AWS
resource, we can do so in Terraform using the `null_resource` type. We can use
`null_resource` if we want to execute commands locally or on the remote server
without creating a specific resource:

```sh
resource "null_resource" "configure_server" {
    triggers = {
        trigger = aws_instance.myapp-server.public_ip
    }
    # Remove from server instance into null_resource block
    provisioner "local_exec" {
        working_dir = "/path/to/ansible/project-dir"
        command = "ansible-playbook --inventory $ {aws_instance.myapp-server.public_ip}, --private-key ${var.ssh_key_private} --user ec2-user playbook-name.yaml"
    }
}
```

- `terraform init` > `terraform apply -f {filename}`
