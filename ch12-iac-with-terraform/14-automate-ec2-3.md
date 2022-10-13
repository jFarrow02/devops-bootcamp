# Demo Project 1 Part 2: Automate AWS Infrastructure

## Run entrypoint script to start Docker container on EC2 instance

We have configured the network on AWS and provisioned a server, but the server
doesn't have any applications running on it yet. With Terraform, there is a way
to execute commands on a server instance at the time of creation, using an
attribute called `user_data`.

`user_data` is a script that gets executed on the server when the server gets
created.

Add the `user_data` attribute according to [main.tf](./12-demo-files/main.tf),
then do `terraform plan` > `terraform apply --auto-approve`. Note that the
`user_data` block will get executed **only once**, on initial run.

## Extract to a Shell Script

If you have a longer set of commands, you can reference them from a **separate
file** and pass the file location to Terraform.

You can now commit all changes and push to remote repo if you wish.

## Configure Infrastructure, not Servers

Note that once the **infrastructure** is created, Terraform does not assist with
deploying **applications/containers**. You _can_ use shell scripts, but
Terraform is not the best tool for deploying apps.

Terraform is a tool for **creating, configuring, and managing infrastructure**.
Deploying the app, configuring the server, etc. should be done with **another
tool**.

Other IAAS tools like Chef, Puppet, or Ansible should be used for automation of
deploying the app, configuring servers, installing/updating packages, etc.

### Configuring Provisioner in Terraform file

`main.tf`

```
connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_location)
  }

  provisioner "remote-exec" {
    inline = [
      "export ENV=dev",
      "mkdir newdir"
    ]
  }
```

- `provisioner`: connects to AWS instance via Terraform

- `terraform plan` > `terraform apply auto-approve`

You can also use the `script` attribute to execute a script on the remote
server, but **the script must already exist on the remote server**.

`main.tf`

```
connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_location)
}

provisioner "file" {
    source = "{local-file-path}"
    destination = "{remote-file-path/filename}"
}

provisioner "remote-exec" {
    script = file("{filename}")
}

provisioner "local-exec" {
    command = "echo ${self.public_ip} > output.txt"
}
```

#### `local-exec`

`local-exec` provisioner invokes a local command/executable **locally** (NOT on
the created resource), after a resource is created.

## Provisioners are NOT Recommended by Terraform!

According to Terraform itself, provisioners are a **workaround**. Terraform
documentation states that better solutions are available, and does **not**
recommend using them:

1. Provisioners break the idempotency concept in Terraform, because we're using
   shell commands/scripts. Terraform has no way of knowing whether the commands
   executed successfully, or whether changes deviate from current state.

### Alternatives:

-`remote-exec`: Use configuration management tools (Chef, Ansible, Salt, etc.).
Once server provisioned, hand over to config management tool.

- `local-exec`: Use "local" provider (HashiCorp)

- execute scripts separately from CI/CD tool (e.g. Jenkins)

## Provisioner Failure

If the provisioner fails, Terraform marks the resource as failed and flagged for
deletion. You will need to re-create the resource.
