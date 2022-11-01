# Project Exercise: Restore EC2 Volume

We now want to use our snapshot(s) to restore a volume from the snapshot, and
attach the new volume to our EC2 instance.

We will create the new volume from the **latest** snapshot.

## Implementation

`restore-volume.py`:

```python
import boto3
from operator import itemgetter

ec2_client = boto3.client('ec2', region_name="eu-west-3")

ec2_resource = boto3.resource('ec2', region_name="eu-west-3")

instance_id = "i-12345678abcdefg" # instance id of the EC2 we want to restore

volumes = ec2_client.describe_volumes(
    Filters=[
        {
            'Name': 'attachment.instance-id',
            'Values': [instance_id]
        }
    ]
)

# We assume the instance has just one volume attached
instance_volume = volumes['volumes'][0]

snapshots = ec2_client.describe_snapshots(
    OwnerIds=['self'],
    Filters=[
        {
            'Name': 'volume-id',
            'Values': [instance_volume['VolumeId']]
        }
    ]
)

# Get sorted list of snapshots for the instance
latest_snapshot = sorted(snapshots['Snapshots'],     key=itemgetter('StartTime'), reverse=True)[0]

# Create a volume from the latest snapshot
new_volume = ec2_client.create_volume(
    SnapshotId=latest_snapshot['SnapshotId'],
    AvailabilityZone="eu-west-3b", # same AZ as server
    TagSpecifications=[
        {
            'ResourceType': 'volume',
            'Tags': [
                {
                    'Key': 'Name',
                    'Value': 'prod'
                }
            ]
        }
    ]
)

while True:
    vol = ec2_resource.Volume(new_volume['VolumeId'])
    if(vol.state == 'available'):
        ec2_resource.Instance(instance_id).attach_volume(
            VolumeId=new_volume['VolumeId'],
            Device='/dev/xvdb' # modify the value for   the   current instance
        )
        break
```
