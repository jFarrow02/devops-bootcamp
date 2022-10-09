# Demo Project 1 Part 2: Automate AWS Infrastructure

## Amazon Machine Image for EC2

You can select the AMI type via the `main.tf` file using the
`resource "aws_instance"` tag. Avoid hard-coding this value as it can change
dynamically.

1. Select the image ID from the AWS management console: Services > EC2 >
   Images > AMIs > search for desired AMI id

2. `main.tf`

```
# query ami id from aws dynamically
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    # define the criteria for the query
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# Optional: validate ami info
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
}
```

Add the `instance_type` environment variable declaration to `main.tf` and set
the value in the `.tfvars` file.

3. Set SSH keys in `main.tf`:
   - NOTE: When creating a new SSH key pair, best practice is to keep in
     `~/.ssh` directory
   - `chmod 400 ~/.ssh/{key-pair-filename}`: Restrict permissions to user-read
     only

`main.tf`:

```
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  # Remaining args are OPTIONAL; instances will
  # be launched in DEFAULT VPC if not specified
  subnet_id = [aws_subnet.myapp-subnet-1.id]
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true # Access from browser and SSH
  key_name = "server-key-pair" # key name in AWS console

  tags = {
    Name = "${var.env.prefix}-server"
  }
}

```

- `terraform plan > terraform apply --auto-approve`

You can now SSH into your server instance:

- `ssh -i ~/.ssh/{key-pairname} ec2-user@{server-public-ip}`

## Automate Creating SSH Key Pair

Manually creating the SSH key pair is not optimal. We can create it
automatically in Terraform.

```
resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = ""
}
```

For the **public_key** value: A key pair must already exist **locally** on your
machine. If you don't already have an `~/.ssh/id_rsa.pub` public key locally,
you can generate one with the following command: `ssh-keygen`.

Once you have the `.id_rsa.pub` file, output the contents into the `public_key`
property. **Best practice is to extract the value into the tfvars file OR
reference file location**; do NOT check in to SCM. See
[12-demo-files/main.tf](./12-demo-files/main.tf) for required changes.

`terraform plan > terraform apply --auto-approve`

### SSH Into Instance

The **private** portion of the public/private key pair is now `~/.ssh/id_rsa`:

- `ssh -i ~/.ssh/id_rsa ec2-user@{public-ip-address}`: You can ssh into the
  remote EC2 instance using your **local** public/private key pair.

You may remove the AWS-generated `.pem` file if you like.
