# Install Terraform and Setup a Project

## Install on Ubuntu/Debian

Installation documentation:
(https://learn.hashicorp.com/tutorials/terraform/install-cli)[https://learn.hashicorp.com/tutorials/terraform/install-cli]

1. Ensure that the `gnupg`, `software-properties-common`, and `curl` packages
   are installed on your system:
   `sudo apt-get update && sudo apt-get install -y gnupg software-properties-common`

2. Install the HashiCorp GPG key:
   `wget -O- https://apt.releases.hashicorp.com/gpg | \ gpg --dearmor | \ sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg `

3. Verify the key's fingerprint:
   `gpg --no-default-keyring \ --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \ --fingerprint `

   The `gpg` command will output the following key fingerprint:

   ```
    gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
    /usr/share/keyrings/hashicorp-archive-keyring.gpg

    pub rsa4096 2020-05-07 [SC] E8A0 32E0 94D8    EB4E A189 D270 DA41 8C88 A321 9F7B
    uid [ unknown] HashiCorp Security (HashiCorp    Package Signing)
    <security+packaging@hashicorp.com> sub    rsa4096 2020-05-07 [E]
   ```

   The fingerprint must match
   `E8A0 32E0 94D EB4E A189 D270 DA41 8C88 A321 9F7B`.

4. Add the official HashiCorp repo to your system:
   `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \ https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \ sudo tee /etc/apt/sources.list.d/hashicorp.list `

5. Download the package information from HashiCorp: `sudo apt upgrade`

6. Install Terraform from the new repository: `sudo apt-get install terraform`

7. Verify that installation succeeded: `terraform -v`

## Install via homebrew, or download binary and setup locally yourself.

1.  `brew install terraform`

2.  `terraform -v`

3.  Upgrade to latest terraform version:

- `brew update`
- `brew upgrade terraform`

## Local Setup: Write a Terraform File and Create AWS Resources

1. Create project folder:

- `mkdir terraform`

2. `touch terraform/main.tf`

3. If in VS Code, install (optionally) HashiCorp Terraform plugin

## Connect to AWS via Terraform

1. Create your `main.tf` file in the desired location:

`main.tf`:

```
provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

```

2. Install provider(s). From the location of your `main.tf` file:

- `terraform init`: Initializes a working directory and installs providers
  defined in the Terraform configuration.

  Note that the `.terraform` directory contains the aws provider code, and the
  `.terraform.lock.hcl` file.

3. Add the following config to your `.tf` file. This defines **globally** which
   provider(s) and which versions the Terraform project uses. This is a best
   practice. See
   [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.33.0"
    }
  }
}

provider "aws" {
  // ...
}
```

**Another common usage** is to create a separate file (e.g. `providers.tf`) with
the same provider(s) configuration.

**NOTE**: Explicitly defining the providers is _optional_ for OFFICIAL HashiCorp
providers, but **REQUIRED for others!**

The provider gives the **entire functionality of the provided API**. Every
service in AWS is available via the provider, for example.
