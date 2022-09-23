# Deploy your App in K8s Cluster from Private Docker Repository

## Common Workflow
1. Commit to SCM
2. Triggers CI build
3. CI build pushes image to (private) regsitry
4. How to get IMAGE running in CLUSTER?

## Steps to Pull Image
1. Create `Secret` K8s component with **credentials** for Docker registry
2. Configure Deployment/Pod to use `Secret` using **imagePullSecrets** attribute.

### Prereqs
1. Private Docker repo (AWS, Dockerhub etc)
2. (Nodejs) app inside the repo
3. Local minikube cluster (empty)

### Steps
1. Login to Docker repo:
    - `aws ecr get-login-password --region {region} | docker login --username AWS --password-stdin 815338849297.dkr.ecr.us-east-1.amazonaws.com`
    - Generates a `.docker/config.json` file that holds authentication credentials. 

2. SSH into minikube:
    - `minikube ssh`

3. Login to privte repo from minikube directly:
    - Copy login command in step 1 and execute.

4. `ls -la`: Find `.docker` directory.

5. `cat .docker/config.json`: Should see authentication credentials. This is the file you need to create the `Secret`.

6. Create Secret Component:

- `kubectl create secret generic my-registry-key \
--from-file=.dockerconfigjson=.docker/config.json \
--type=kubernetes.io/dockerconfigjson`

**OR**

- kubectl create secret docker-registry my-registry-key-two \
--docker-server={aws-ecr-url} \
--docker-username=AWS \
--docker-password={.docker/config.json.docker-password}`

`docker-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: my-registry-key
data:
    .dockerconfigjson:
type: kubernetes.io/dockerconfigjson

```

7. Create Deployment Component:

`my-app-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: my-app
    labels:
        app: my-app
spec:
    replicas: 1
    selector:
        matchLabels:
            app: my-app
    template:
        metadata:
            labels:
                app: my-app
        spec:
            imagePullSecrets:
            - name: my-registry-key
            containers:
            - name: my-app
              image: 815338849297.dkr.ecr.us-east-1.amazonaws.com/{image-name}:{image-tag}
              imagePullPolicy: Always # Forces docker to re-pull image even if it exists locally
              ports:
                - containerPort: 3000

```

- `kubectl apply -f my-app-deployment.yaml`

**NOTE:** The Secret must be in the **same namespace** as the **Deployment**.