# Deploy to LKE Cluster from Jenkins Pipeline

- Create a K8s cluster on Linode Kubernetes Engine (LKE)

- use `kubeconfig` file to connect and authenticate

## Steps to Configure:

1. Have `kubectl` command available in Jenkins container (done if you completed
   previous chapter)

2. Install K8s CLI Jenkins Plugin to execute kubectl with kubeconfig credentials

3. Configure Jenkinsfile to deploy to LKE cluster

## Step 1

1. Create cluster in LKE UI. Download the `kubeconfig` file from LKE.

2. `export KUBECONFIG=~{kubeconfig-file-location}`

3. From Jenkins UI: > Credentials > Folder > Global credentials, create new
   credential:
   - Kind: Secret file
   - File: upload the `kubeconfig` file from your local machine
   - ID: set an id
   - Create

## Step 2

1. Jenkins > Manage Jenkins > Plugin > Search for "kubernetes cli" > install
   without restart

## Step 3

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

            steps {
                script {
                    echo "deploying docker image..."
                    withKubeConfig([credentialsId: '{credential-name}', serverUrl: '{kubernetes-api-endpoint-from-lke-dashboard}']) {
                        sh 'kubectl create deployment nginx-deployment --image=nginx'
                    }
                }
            }
        }
    }
}
```

Check Jenkinsfile changes in to SCM and verify pipeline completed successfully.

- `kubectl get pod`
