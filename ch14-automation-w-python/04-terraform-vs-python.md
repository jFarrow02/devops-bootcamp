# Terraform vs. Python: When to Use Which?

| Terraform | Python |
|-----------|--------|
| Manages and knows current state vs. configured/desired state           | Does **not** maintain state; Python does not know about current state of infrastructure |
| Idempotent; multiple execution of same config will produce same result | **Non-idempotent**; multiple execution of same config will **duplicate** results        |
| Deleting resources as easy as deleting configuration from config file  | Must **explicitly** delete resources (and any _dependent_ resources, g.g. subnets)      | High-level syntax is and easier to write | Low-level programming syntax is more difficult to write |

## Why Use Boto3 if it's HARDER?

With `boto3`, you have **much** more functionality. You can do much more and
more complex actions with `boto3` than you can with Terraform. It is more
powerful and flexible than Terraform. Python is also a great choice because of
its many libraries.

Also, you can easily add a **web interface** to your Boto/Python application!
