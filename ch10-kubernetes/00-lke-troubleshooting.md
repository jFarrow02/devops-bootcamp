curl -LO https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl

curl -LO "https://dl.k8s.io/$(curl -L -s
https://dl.k8s.io/release/1.24.0.txt)/bin/linux/amd64/kubectl.sha256"
