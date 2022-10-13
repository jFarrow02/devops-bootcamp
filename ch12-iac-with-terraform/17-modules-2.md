# Modules in Terraform: Part 2

## Modularize our Project

We can now modularize our project by turning our `main.tf` file into multiple
files.

It is a common practice sto structure your terraform project in the following
way:

```
|-.terraform
|-.terraform.lock.hcl
|-main.tf
|-variables.tf
|-outputs.tf
|-providers.tf
|-terraform.tfstate
|-terraform.tfvars
```

## Create a New Module

Create a folder for each desired new module in the `terraform` root folder with
the following structure:

```
|-module_name
    |-main.tf
    |-variables.tf
    |-outputs.tf
    |-providers.tf
```
