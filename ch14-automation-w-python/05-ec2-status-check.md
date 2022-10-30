# Project: EC2 Server Status Checks

Scenario: We have 100s of ec2 instances with Terraform. Autoscaling is
configured; new instances are created/deleted all the time. We want to know
which instances are in which state at any given time. How can we do this with
`boto3`?

## Step 1: Create EC2 Instaces with TF

_See terraform module notes for how to do this. Note that you'll need to create
multiple instances for this demo to work._

## Step 2: Print EC2 Instance State

`main.tf`:

```python
import boto3

ec2_client = boto3.client('ec2', region_name="eu-central-1")

ec2_resource = boto3.resource('ec2', region_name="eu-central-1")

# Get all instances from the region
reservations = ec2_client.describe_instances()
for reservation in reservations["Reservations"]:
    instances = (reservation["Instances"])
    for instance in instances:
        print(f"Status of instance {instance['InstanceId']} {instance['State']['Name']}")
```

## Step 3: Print EC2 Status Check

`main.tf`:

```python
# ...

reservations = ec2_client.describe_instances()
for reservation in reservations["Reservations"]:
    instances = (reservation["Instances"])
    for instance in instances:
        print(f"Status of instance {instance['InstanceId']} {instance['State']['Name']}")

# Get instance status for all instances in region
status_list = ec2_client.describe_instance_status()

for status in status_list["InstanceStatuses"]:
    ins_status = status['InstanceStatus']['Status']
    sys_status = status['SystemStatus']['Status']
    print(f"Instance {status['InstanceId']} status is {ins_status} and system status is {sys_status}")
```
