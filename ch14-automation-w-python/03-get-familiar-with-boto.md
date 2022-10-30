# Getting Familiar with Boto3

`boto3` can do **much** more than Terraform. **You will need to refer to the
documentation frequently** to figure out how to do the task you want to
complete!

### [Boto3 documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

## Using Boto3

`main.py`:

```python

import boto3

# Print select information fo all available VPCs in default AZ

ec2_client = boto3.client("ec2")

available_vpcs = ec2_client.describe_vpcs()

vpcs = available_vpcs["Vpcs"]

for vpc in vpcs:
    print(vpc["VpcId"])
    cidr_block_assoc_sets = vpc["CidrBlockAssociationSet"]
    for assoc_set in cidr_block_assoc_sets:
        print(assoc_set["CidrBlockState"])
```

### Connecting to Non-default region

`main.py`:

```python

import boto3

# pass "region_name" param to connect to desired region
ec2_client = boto3.client("ec2", region_name="us-west-1")

# ...
```

Note the use of **named parameter** `region_name`. This tells Python which value
you are providing for **which parameter**.

### Create VPC and Subnet with Boto3

`client` vs. `resource`:

| `client`                                                      | `resource`                                                         |
| ------------------------------------------------------------- | ------------------------------------------------------------------ |
| more low-level API                                            | high-level, object-oriented                                        |
| provides one-to-one mapping to underlying HTTP API operations | provides resource objects to access attributes and perform actions |

Think of `resource` as a more convenient way to access AWS capabilities.

`main.py`:

```python

import boto3

ec2_client = boto3.client("ec2")

ec2_resource = boto3.resource("ec2", region_name="eu-central-1")

# Create VPC

# resource returns us an object on which we can make subsequent calls
new_vpc = ec2_resource.create_vpc(
    CidrBlock="10.0.0.0/16"
)

# Create two new subnets on your vpc
new_vpc.create_subnet(
    CidrBlock="10.0.1.0/24"
)

new_vpc.create_subnet(
    CidrBlock="10.0.2.0/24"
)

# Add tags to the vpc
new_vpc.create_tags(
    Tags=[
        "Key": "Name",
        "Value": "my-vpc"
    ]
)

available_vpcs = ec2_client.describe_vpcs()

vpcs = available_vpcs["Vpcs"]

for vpc in vpcs:
    print(vpc["VpcId"])
    cidr_block_assoc_sets = vpc["CidrBlockAssociationSet"]
    for assoc_set in cidr_block_assoc_sets:
        print(assoc_set["CidrBlockState"])
```
