# Create EKS Cluster with `eksctl` Command Line Tool

Previously we created the EKS cluster and node groups **manually**. These steps
are time-consuming and difficult to replicate if you need the same cluster
environment multiple times.

One of the easiest ways to do this is using `ekstl` command line tool for
creating EKS clusters in AWS. Executes just one command and all the necessary
components get created and configured in the background. With cli options you
can customize your cluster.

## Creating a Cluster with `eksctl`
