# Deploy to EKS Cluster from Jenkins

There are several steps to configure in order to deploy to K8s cluster from
Jenkins:

## Install kubectl command line tool inside Jenkins container

1. SSH into Jenkins container
2. `docker exec -u 0 -it {container-id} bash`
3. Install `kubectl` in container (see kubectl docs for installation
   instructions)

## Install aws-iam-authenticator tool inside Jenkins container (to authenticate with AWS and K8s cluster)

1. Download `aws-iam-authenticator` (see installation instructions in AWS docs)

2. `chmod +x ./aws-iam-authenticator`

3. `mv ./aws-iam-authenticator /usr/local/bin`: Move executable to
   /usr/local/bin (if not already in that directory)

4. `aws-iam-authenticator help`: Verify that aws-iam-authenticator command is
   available.

## Create kubeconfig file to connect to EKS cluster (contains all the necessary info for authentication)

1. Exit Jenkins container and create `kubeconfig` file on the host:
   - vim config
   - Copy config file contents from AWS documentation
   - change <cluster-name> to your cluster name
   - change <endpoint> to `Api server endpoint` value in EKS "Details" section
     of AWS console
   - On HOST machine: `cat .kube/config`. Copy `certificate-authority-data` in
     this file to `certificate-authority-data` in vim file
   - Enter JENKINS container again: `docker exec -it {container-id}} bash`
   - `cd ~`: Enter Jenkins home directory for Jenkins user
   - `mkdir .kube`
   - `exit`
   - `docker cp config {container-id}:/var/jenkins_home/.kube/`
   - enter Jenkins container again
   - cd to Jenkins home dir `ls -la .kube`: verify that config file exists with
     correct data
   - `exit`: Exit Docker container

## Add AWS credentials on Jenkins for AWS account authentication (Access Key and Secret Access Key)

Now we need credentials for the AWS user. Best practice is to create an AWS IAM
user for Jenkins. For simplicity we'll use the existing Jenkins admin user.

- Jenkins UI > Credentials > Add Credentials > Kind = Secret text

- `~/.aws`: Storage location of credentials for current user. Secret = the key
  id in this file. ID = `jenkins_aws_access_key_id`. Save and click "OK".

- Do the above process for the AWS Secret Access Key as well.

## Adjust Jenkinsfile to configure EKS cluster deployment

```groovy
#!/usr/bin/env/ groovy

pipeline {
    agent any
    stages {
        stage('build app') {
            steps {
                script {
                    echo "building the application..."
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                }
            }
        }
        stage("deploy") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
            }
            steps {
                script {
                    echo "deploying docker image..."
                    sh 'kubectl create deployment nginx-deployment --image=nginx'
                }
            }
        }
    }
}

```

## Execute Jenkins Pipeline

- Save changes to Jenksinfile and push to SCM for deployment in Jenkins pipeline

- Configure Jenkins to run on push to your SCM branch via Jenkins UI

- `kubectl get pod`
