# Data Backup: Project Exercise

In this exercise we wil create snapshots of **volumes**, AWS storage components
that store EC2 instance data (think **hard drive** for EC2 instance).

A **snapshot** is a **copy of a volume** at a point in time. Snapshots are very
important for data backup and recovery in case an EC2 instance dies, the volume
gets deleted or corrupted, etc.

Let's create a Python program to create snapshots daily at a specified time.

## Prep: Create EC2 Instances

- Create 2 EC2 instances: one with tag `Name: dev` and one with tag
  `Name: prod`. You can do this with the AWS Console, from CLI, etc.
- Verify that a volume has been attached to each instance.
- Verify that the "Snapshots" are empty for each of the new volumes.

## Automate Volume Snapshot Creation

`create_volume.py`:

```python

import boto3

# Get volumes for your specific region

ec2_client = boto3.client('ec2', region_name="eu-west-3")

volumes = ec2_client-describe_volumes()

print(volumes['Volumes']) # List of volumes
volumes_list = volumes['Volumes']

for volume in volumes_list:
    new_snapshot = ec2_client.create_snapshot(
        VolumeId=volume['VolumeId']
    )
    print(new_snapshot)
```

### Implement Schedule for Automated Scheduled Backups

`create_volume.py`:

```python

import boto3
import schedule

# Get volumes for your specific region

ec2_client = boto3.client('ec2', region_name="eu-west-3")

# Refactor snapshot create logic into a function
def create_volume_snapshots():
    volumes = ec2_client-describe_volumes()

    print(volumes['Volumes']) # List of volumes
    volumes_list = volumes['Volumes']

    for volume in volumes_list:
        new_snapshot = ec2_client.create_snapshot(
            VolumeId=volume['VolumeId']
        )
        print(new_snapshot)

# Run the function every (x) days
schedule.every(1).day.do(create_volume_snapshots)

while True:
    schedule.run_pending()
```

## Backup Only Prod Servers

`create_volume.py`:

```python

import boto3
import schedule

ec2_client = boto3.client('ec2', region_name="eu-west-3")

def create_volume_snapshots():
    volumes = ec2_client-describe_volumes(
        # Filter out non-prod volumes and create snapshots only for prod volumes
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': ['prod']
            }
        ]
    )

    print(volumes['Volumes'])
    volumes_list = volumes['Volumes']

    for volume in volumes_list:
        new_snapshot = ec2_client.create_snapshot(
            VolumeId=volume['VolumeId']
        )
        print(new_snapshot)

schedule.every(1).day.do(create_volume_snapshots)

while True:
    schedule.run_pending()
```
