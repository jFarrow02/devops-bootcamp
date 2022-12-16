# Environment Variables in Terraform

**Hardcoding credentials in a Terraform file is a bad practice!** You may be
checking these files into SCM, and therefore exposing sensitive credentials. A
**better practice** is to use **environment variables** or Cloud Provider
credentials.

## Setting AWS Credentials in Terrafrom

- `ls ~/.aws/credentials`: List the default location for AWS credentials

- `aws configure`: Enter access key and secret access key. The
  `.aws/credentials` and `.aws/config` files will be generated/updated.

- `terraform apply -var-file {tf-var-filename}.tfvars`: Terraform will be able
  to use the credentials and authenticate with no additional configuration.

## Set Global Env Variables using`tf_var` Prefix

- `export TF_VAR_avail_zone="eu-west-3a"`: Set the env var with the TF_VAR
  prefix
- Declare the variable inside the`.tfvars` file:

```
  provider "aws" {}
  // ...
  // Declare the "avail_zone"variable
  variable avail_zone{}
  // use the variable
  resource "aws_subnet""dev-subnet-1" {
      vpc_id = aws_vpcdevelopment-vpc.id
      cidr_block = var.cidr_block[1].cidr_block
      availability_zone = var.avail_zone
      tags = {
          Name: var.cidr_block[1].name
      }
  }
```

`terraform apply -var-file{tf-var-filename}.tfvars`
