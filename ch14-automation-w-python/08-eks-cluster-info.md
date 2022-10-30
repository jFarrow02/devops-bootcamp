# Print EKS Cluster Information

Imagine we have 10 EKS clusters in our AWS account. We want to have an overview
of all our running clusters:

- status
- which K8s version
- cluster endpoint

We can write a Python program that outputs this information for us.

## Step 1: Create EKS Cluster

_Refer to Terraform module notes for how to do this step._

## Step 2: Write Python Script

`eks-status-checks.py`:

```python
import boto3

eks_client = boto3.client('eks', region_name="eu-west-3")

clusters = eks_client.list_clusters()
cluster_list = (clusters["clusters"])

for cluster in cluster_list:
    response = client.describe_cluster(
        name=cluster
    )
    cluster_info = response['cluster']
    cluster_status = cluster_info['status']
    cluster_endpoint = cluster_info['endpoint']
    cluster_version = cluster_info['version']
    print(f"Cluster {cluster} status is {cluster_status}")
    print(f"Cluster {cluster} endpoint is {cluster_endpoint}")
    print(f"Cluster {cluster} version is {cluster_version}")
```
