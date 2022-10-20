# Managed K8s Services

## Hypothetical Use Case

1. Web app with database
2. Available from browser with https
3. security for cluster
4. Data persistence for database
5. Dev and prod environment
6. **Setup as efficient as possible**

## Managed vs. Unmanaged K8s Cluster

For K8s cluster on a Cloud platform, you have 2 options:

1. Create own cluster from scratch:

   - You must install all binaries, processes, and manage everything yourself
   - Not practical when you want to setup quickly

2. Use a **Managed** K8s service:
   - Provided by cloud plaform; no need to create cluster from scratch
   - You just choose how many worker nodes
   - Docker runtime pre-installed
   - Provider creates and manages Manager nodes
   - Less effort and time

## Managed K8s Cluster with Linode K8s Engine as Example

1. Spin up K8s cluster on cloud on LKE
2. Choose worker nodes with resources in Linode UI
3. Select region/data center
4. Connect to cluster from laptop with kubectl

### Data Persistence for your Cluster

1. Use Linode Storage Class
2. Linode creates persistent vols with physical storage

### Load Balancing K8s Cluster

Configure Services and Ingress:

1. Install and run IngressController on cluster:
   - Cloud proider has own load balancer implementation
   - For Linode, it's NodeBalancer. Provides public IP address in front of app
     server(s)
   - Can secure your conection with SSL Cert: configure with cert-manager
2. Use availability zones to move content closer to where your customers are
3. Move app from one cloud to another:
   - Usually services are tied to a specific provider; migrations difficult
     ("vendor lock-in")
4. Automating tasks should be done as much as possible using automation tools:
   - Terraform
   - Ansible
