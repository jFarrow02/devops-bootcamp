# Terraform State

Terraform keeps track of current state and reads desired state from
configuration file. How does Terraform know what current state of resources is?

In the terraform folder there are two files (generated on the first `apply`):

- `terraform.tfstate`: A JSON file where terraform stores the state about your
  real world resources of your managed infrastructure

- `terraform.tfstate.backup`: Stores the **previous** state of the Terraform
  resources

## Accessing State Information

- `terraform state`: Lists available subcommands

- `terraform state list`: List resources in the state

- `terraform state show {resource-name}`: Shows state of specific resource
  `resource-name`
