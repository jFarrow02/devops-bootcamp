# Add EC2 Instances to Inventory

1. Launch new EC2 instance(s) of size/type of your choice. Create a new key pair
   if desired.

2. Configure servers in `hosts` file:

`hosts`:

```
#...

[ec2]
ec2-000-000-000-000.us-east-1.compute.amazonaws.com ansible_python_interpreter=/usr/bin/python3
ec2-000-000-000-001.us-east-1.compute.amazonaws.com ansible_python_interpreter=/usr/bin/python3
myapp.com # if server has a domain name registered

[ec2:vars]
ansible_ssh_private_key_file={private-key-file-location}
ansible_user=ec2-user
```

3. Install python3 (on each server):

- `sudo yum install python3`

4. Ping servers:

- ``ansible ec2 -i hosts -m ping`
