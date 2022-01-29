# K8s Namespaces

## What is a Namespace?

In K8s, you can organize resources in **namespaces**. Think of it as a virtual cluster inside a cluster. 

4 namespaces by default:
1. kubernetes-dashboard: only with minikube
2. kube-system: NOT for your use. System processes only
3. kube-public: Contains publicly accessible data
4. kube-node-lease: holds info about the availability of nodes
5. default: resources you create are located here by default.

## Adding a Namespace
- `kubectl create namespace [namespace-name]`
- OR, use a namespace file.

## Why Namespaces?
- Avoid cluttering the default namespace with lots of components
- Better visibility if you group resources by namespaces, e.g.
    - Database ns
    - Monitoring ns
    - nginx-ingress ns
    - etc.
- Avoid conflicts when multiple teams create deployments of the same application w/o disruption
- Host different environments (staging, development) in diff ns, host common services in another ns
- Blue/Green deployments
- Access and Resource Limits on Namespaces
    - give teams access to only their namespace; no access to other namespaces
    - limit CPU, RAM, storage per ns

## Characteristics of Namespaces
- Cannot access most resources from another namespace
    - each ns must define its own ConfigMap
    - use **shared** resources by appending namespace name to end of service name
- Cannot create certain components w/in a namespace:
    - volumes
    - nodes

## Creating Components in Namespaces
1. Use `--namespace` flag with `kubectl apply`:
    `kubectl apply -f [config-file].yaml --namespace=[namespace-name]`

2. Inside config file:
    ```
    apiVersion: v1
    //...
    metadata:
        name: component-name
        namespace: namespace-name
        //...
    ```
    `kubectl get [component] --namespace=[namespace-name]`

## Change Active Namespace
You can change your active namespace to avoid having to type namespace with all your `kubectl` commands. Must install `kubens` tool:
- `brew install kubectx`
- `kubens`: get all namespaces
- `kubens [namespace-name]`: switch active namespace
