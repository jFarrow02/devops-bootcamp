# Private Docker Repositories w/ AWS ECR

AWS ECR (Elastic Container Registry) is a service that provides private repository space for storing images.

## Pushing an Image to ECR
1. Create a new ECR repository:
    - AWS console > ECR > Repositories > Create repository
    - Choose a public or private repository
    - > Create repository

2. For **private** repositories:
    - Retrieve an authentication token and authenticate your Docker client to your registry:
        - `aws ecr get-login-password --region <aws-region> | docker login --username <username> --password-stdin <repo-uri>`
        - Note: You may need to run `aws configure` from terminal to configure user access

    - Build your Docker image using the following command: `docker build -t <image-name> <dockerfile-location>`

    - After the build completes, tag your image so you can push the image to the repository:
    `docker tag <imagename>:<tag> <repo-uri>/<imagename>:<tag>`

    - Push the image to your newly-created AWS repo:
    `docker push <repo-uri>/<imagename>:<tag>`
