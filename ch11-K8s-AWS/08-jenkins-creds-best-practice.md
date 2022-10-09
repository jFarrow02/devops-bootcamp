# Credentials in Jenkins

We have configured credentials inside Jenkins for deploying to EC2 as well as
LKE.

For EC2, we have created an SSH credential for EC2 user on that instance and
provided the private SSH key for that user. An alternative would be to create a
Jenkins user (in Linux) on the EC2 server and then create credentials for the
Jenkins user (not the EC2 user) and use the Jenkins user credentials. The
Jenkins user would have only the permissions that Jenkins needs to deploy. This
is a best practice as it adheres to least permissions principle.
