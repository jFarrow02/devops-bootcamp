# Modules in Terraform: Part 1

The more resources we add, the bigger and more complex the `main.tf` file gets.

In Terraform, **modules** organize and group configurations into logical groups.

Terraform modules are analogous to **function definitions** in programming. We
cand pass in **input variables** like function arguments, and return **output
values** like function return values.

It makes sense to create a module when you want to group various resources
together logically (e.g. a VPC module, a server module, etc.).

## Use Existing Modules

We can create our own modules, but we can also re-use existing modules created
by others!

Terraform maintains a repository of modules for use in the Terraform
documentation.
