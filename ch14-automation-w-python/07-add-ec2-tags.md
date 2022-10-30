# Configure Server: Add Env Tags to EC2 Instances

`add-env-tags.py`:

```python
import boto3

# Paris region
ec2_client = boto3.client('ec2', region_name="eu-west-3")

ec2_resource_paris = boto3.resource('ec2', region_name="eu-west-3")

# Frankfurt region
ec2_client = boto3.client('ec2', region_name="eu-west-1")

ec2_resource_paris = boto3.resource('ec2', region_name="eu-west-1")


# Add "environment:prod" tag to all Frankfurt instances
instance_ids_paris = []

reservations_paris = ec2_client_paris.describe_instances()['Reservations']

for res in reservations_paris:
    instances = res['Instances']
    for ins in instances:
        instance_ids_paris.append(ins['InstanceId'])

response = ec2.create_tags(
    Resources=instance_ids_paris,
    Tags=[
        {
            'Key': 'environment',
            'Value': 'prod'
        }
    ]
)

# Add "environment:dev" tag to all Frankfurt instances
instance_ids_frankfurt = []

reservations_frankfurt = ec2_client_frankfurt.describe_instances()['Reservations']

for res in reservations_frankfurt:
    instances = res['Instances']
    for ins in instances:
        instance_ids_frankfurt.append(ins['InstanceId'])

response = ec2.create_tags(
    Resources=instance_ids_frankfurt,
    Tags=[
        {
            'Key': 'environment',
            'Value': 'dev'
        }
    ]
)
```

`ec2-status-checks.py`:

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
