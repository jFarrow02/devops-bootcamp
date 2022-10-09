# Change & Destroy Terraform Resources

## Changing Resources

```
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

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    availability_zone = "eu-west-3a"
    tags = {
        Name: "subnet-2-default"
    }
}
```

- `terraform apply` > `yes`

## Removing/Destroying Resources

There are 2 ways of removing a resource:

1. Remove it from Terraform file, and run `terraform apply` again

2. Use `terraform destroy` command, passing in resource name:

   - `terraform destroy --target {resource-type} {resource-name}`

   - `terraform destroy --target aws-subnet dev-subnet-2`

**Prefer `terraform apply` in order to maintain consistency between config file
and existing resources!**
