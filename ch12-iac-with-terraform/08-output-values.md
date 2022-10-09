# Output Values

Terraform allows us to output a set of attributes and their values of the
resources created. We can see the values in the terraform.tfstate file or via
commands.

Another way is to use **output values**:

```
``
provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

resource "aws_vpc" "development-vpc" {
    cidr_block = "10.0.0.0/16"
    # add key/value pair tags to resource
    tags = {
        Name: "development"
        vpc_env: "dev"
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id # Reference the vpc id of the vpc to be created
    cidr_block = "10.0.10.0/24"
    availability_zone = "eu-west-3a"
    tags = {
        Name: "subnet-1-dev"
    }
}

# Outupt IDs of all resources created
output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}
```

- `terraform apply -auto-approve`
