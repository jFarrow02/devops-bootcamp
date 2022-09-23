## Create an EKS Cluster with AWS Management Console

**Step 1: Create IAM Role:**
- Create IAM role in AWS to allow AWS to create/manage components on our behalf

- Assign role to EKS cluster managed by AWS:

1. AWS Console > AWS Service > EKS > EKS Cluster > AmazonEKSClusterPolicy
2. (Optional) Add tags for role > Next
3. Add role name, description (optional) > Create Role

**Step 2: Create VPC for Worker Nodes:**
- Why do we need to create another VPC? Because EKS cluster needs a specific networking configuration. K8s specific and AWS specific networking rules **must work together**. Default VPC is **not** optimized for this. Also, worker nodes need specific firewall configs for manager/worker nodes to communicate.

- Best practice: configure public subnet and private subnet

- Give K8s permission to change VPC configs through IAM role

**Use AWS-provided template to create your VPCs (CloudFormation template)**:
1. AWS Console > CloudFormation > Create stack
2. Specify template > Amazon S3 url
3. Copy link from EKS user guide to create public/private subnets and paste > Amazon S3 Url > Next
4. Add stack name, advanced options (optional) > Next
5. Review configuration > Create stack

**Step 3: Create EKS cluster (Manager Nodes):**
1. AWS Console > Services > EKS > Create EKS cluster > input cluster name
2. Enable envelope encryption (optional if K8s Secret encryption is needed) > Next
3. Specify networking > select VPC where worker nodes are running (NOT the default VPC) > select security group of worker nodes VPC
4. Cluster endpoint access:
    - Public: accessible from outside VPC (e.g. kubectl)
    - **Public and Private**: accessible only within our VPC (worker nodes can talk directly to manager nodes) (optimal)
    - Private: clients cannot access K8s endpoints except through worker nodes > Next
5. Enable logging for control plane/manager nodes (optional) > Next
6. Review and create cluster > Create

**Step 4: Connect local `kubectl` with EKS cluster:**
1. `aws configure list`
2. `aws eks update-kubeconfig --name <cluster-name>`
3. `cat <kubeconfig-filename>`
4. `kubectl cluster-info`

**Step 5: Create EC2 IAM role for Node Group:**
- Manager nodes (control plane) is created for you; you must create the worker nodes for your EKS cluster.

- Worker nodes run worker processes, e.g. Kubelet (for scheduling, manageing pods, and **communciating with other AWS services**).

- Kubelet on worker node (EC2 instance) needs **permission to interact w/ AWS services**.

Create role for EC2 instance:
1. AWS Console > IAM > Create Role > EC2 > Next
2. Attach permissions policies:
    - AmazonEKSWorkerNodePolicy
    - AmazonEC2ContainerRegistryReadOnly
    - AmazonEKS_CNI_Policy
3. Next > Review > add role name and optional metadata > Create role

**Step 6: Create Node Group and Attach to EKS cluster:**
- Now that you've created the role, you can add node groups to your EKS cluster
1. AWS Console > Services > EKS
2. Select your cluster name > Node Group configuration
3. Add node group name. Select previously-created EC2 role > Next
4. Configure your EC2 image, instance type, volume size
5. Node group scaling configuration:
    - minimum size
    - maximum size: max number of nodes the group can scale out to
    - desired size: Desired number of nodes that the group should launch initially
6. Next > Specify networking > Select SSH key pair for connecting to EC2 worker nodes from ssh, or create new SSH key pair
7. Next > Review and Create > Create
8. `kubectl get nodes`: should see your nodes after a few minutes

**Step 7: Configure Auto-scaling:**

**Step 8: Deploy Application to EKS Cluster:**