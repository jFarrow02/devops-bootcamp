# Container Services on AWS

## Container Orchestration Tools
Help you with managing, scaling and deploying containers. Examples include:
- Kubernetes
- Mesos
- Nomad (Hashi Corp)
- Docker Swarm
- **ECS**: Elastic Container Service (AWS)

## What is ECS?
ECS is a container orchestration service. It allows you to run containerized application clusters on AWS. The ECS cluster contains all the services to manage the containers. The containers are hosted on EC2 instances managed by the ECS cluster, **however you still have to manage the EC2 instances**:
- Create the instances
- Join to ECS cluster
- manage OS
- Ensure you have enough resources (CPU, disk storage)
- Manage Docker runtime and ECS agent

## ECS with Fargate
If you want to delegate the management of the **infrastructure** along with the containers, AWS Fargate is the alternative. **Fargate** is a serverless (meaning server lives in AWS account, not in your account) way to launch containers. No need to provision and manage servers. Fargate analyzes your container, determines what resources (storage, CPU, RAM) needed to run it, and provisions a server with the required resources.
- Pay for what you use
- No need to provision and manage servers
- easily scales up and down
- You only need to manage your application
However, ECS is specific to AWS. If you decide to migrate to another provider later, it will be difficult.

## EKS (Elastic Kubernetes Service)
If you want to use K8s on AWS, use **EKS**. Manages K8s clusters on AWS infrastructure. It is an **alternative** to ECS for users who are using K8s and want to deploy K8s clusters on AWS infrastructure. **Easier to migrate if necessary as K8s is open-source**.

### How does EKS Work?
1. Create an EKS Cluster. EKS deploys and manages K8s Manager Nodes. EKS automatically replicates manager nodes across AZs.
2. You create "Compute Fleet" (multiple EC2 instances) as worker nodes that are **self-managed** (managed by you) or **semi-managed** (creates, deletes intances for you, but you need to configure it)
3. EKS with Fargate gives you fully-managed worker nodes with fully-managed control plane

### Setting up an EKS Cluster
1. Provision an EKS cluster with Manager nodes
2. Create a group of EC2 instances (nodegroup) of worker nodes
3. Connect nodegroup to EKS cluster, or use Fargate
4. Deploy your containerized apps in the EKS cluster using kubectl commands.

## ECR (Elastic Container Registry)
A repository for container images (alternative to Nexus, etc). Integrates well with other AWS services.

