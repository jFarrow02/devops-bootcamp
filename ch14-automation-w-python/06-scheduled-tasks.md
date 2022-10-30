# Write a Scheduled Task in Python

We want to get live updates of the EC2 instance status, so we need a
**scheduler** that triggers the program automatically and periodically.

## Add Scheduler Library to our Project

In your project:

- `pip install schedule`

In `main.py`:

```python
import boto3
import schedule # import schedule library

ec2_client = boto3.client('ec2', region_name="eu-central-1")

ec2_resource = boto3.resource('ec2', region_name="eu-central-1")


def check_instance_status():
    status_list = ec2_client.describe_instance_status(
        IncludeAllInstances=True # get ALL instances' status, including non-running instances
    )

    for status in status_list["InstanceStatuses"]:
        ins_status = status['InstanceStatus']['Status']
        sys_status = status['SystemStatus']['Status']
        print(f"Instance {status['InstanceId']} status is {ins_status} and system status    is {sys_status}")

# Schedule instance checks to run every 5 mins with schedule package
schedule.every(5).minutes.do(check_instance_status)

while True:
    schedule.run_pending()
```
