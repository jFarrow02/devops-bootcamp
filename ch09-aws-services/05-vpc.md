# VPC - Manage Private Networks on AWS

Each region has its own **VPC**: your own private network isolated from other
private networks running on the same physical server in the cloud. VPC spans all
the AZ in the region.

A VPC includes a virtual representation of network infrastructure.

## Subnets

Subnets are sub-networks of the VPC. A subnet exists inside a single AZ.

### Private and Public Subnet

Firewall rule configurations make a subnet either private or public. By creating
a rule excluding external traffic to the subnet, you make it private.

Typical use case: have a private subnet where the DB is running, and a public
subnet that allows external traffic to port 8000 for a web application.

## Secure Your Components

Firewall configs secure your components, control access to your VPC and server
instances.

Can configure access rules on the **subnet** level or the **instance** level:

1. **Subnet** level: Use NACLs to configure access rules
2. **Instance** level: use security groups to configure access rules
