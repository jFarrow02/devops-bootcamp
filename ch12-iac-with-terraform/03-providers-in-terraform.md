# Providers in Terraform

## Connect to AWS Account with a Provider

A **Provider** is a program that knows how to interface with a specific provider
technology (e.g. AWS, GCP, K8s etc.)

(Terraform Providers)[registry.terraform.io/browse/providers]

**Tip**: Terraform is well-documented! See the official docs for examples on how
to create infra resources with Terraform.

### Install and Connect to Provider

Inside `terraform` directory:

`main.tf`:

```
provider "aws" {
    // config to allow tf to connect to our AWS account
    region = "{your-aws-region}"
    access_key = "{your-access-key}" // Don't hard code in SCM files
    secret_key = "{your-secret-access-key}"
}
```

From terminal:

- `terraform init`

Generates hidden folder `.terraform` and hidden file `.terraform.lock.hcl`.

After provider is required, you can use resources it provides. The **complete**
AWS API is available.
