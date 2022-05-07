# Basic Kubectl Commands

**_NOTE:_** Use the syntax `minikube kubectl -- <cmd> <resource>` on Linux machines

1. **Get Status of Components**:
    - `kubectl get nodes`
    - `kubectl get pods`
    - `kubectl get services`
    - etc.

2. **Create Components**:
    - `kubectl create {component}`
    - See `kubectl create help` for list of available components

3. **Create Pod**:
    - Pods are the smallest unit in K8s, but you don't create pods directly. Instead, you create **deployments**, abstraction over pods.
    - `kubectl create deployment {deployment-name} --image={image} [--dry-run] [options]`
    - **Replica Set** manages replicas of the pod. You will never work directly with the replica set.

4. Layers of Abstraction
    |-Deployment: manages a...
        |-ReplicaSet: manages a...
            |-Pod: is an abstraction of...
                |-Container
    Everything below a deployment is managed by K8s.

5. **Edit a Deployment**:
    - `kubectl edit deployment [depl-name]`: returns an auto-generated config file for deployment

6. **Debugging Pods**:
    - `kubectl logs [pod-name]`
    - `kubectl describe pod [pod-name]`: shows state changes in pod
    - `kubectl exec -it [pod-name] --bin/bash`: get interactive terminal of container running in [pod-name]

7. **Delete Deployment**:
    - `kubectl get deployment`
    - `kubectl delete deployment [depl-name]`

8. **Create/Update a Deployment from a K8s Configuration File**:
    - `kubectl apply -f [file-name]`