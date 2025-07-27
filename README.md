# Project goal

Build and deploy a complete DevOps infrastructure on AWS using Terraform, including the following components:

- Deploy a Kubernetes cluster (EKS) with CI/CD support
- Integrate Jenkins to automate build and deployment
- Install Argo CD for application management
- Configure a database (RDS or Aurora)
- Organize a container registry (ECR)
- Monitoring with Prometheus and Grafana

## Table of contents

- [Technical Details](#technical-details)
- [Prerequisites](#prerequisites)
- [Set up the environment](#set-up-the-environment)
- [Deploy the application](#deploy-the-application)
  - [Push the image to the ECR](#push-the-image-to-the-ecr)
  - [Connect kubectl to your cluster](#connect-kubectl-to-your-cluster)
  - [Check the services in the cluster](#check-the-services-in-the-cluster)
  - [Set up automatic CI](#set-up-automatic-ci)
  - [Verify the CD](#verify-the-cd)
  - [Check performance stats](#check-performance-stats)
- [Destroy the environment](#destroy-the-environment)

## Technical Details

`Infrastructure`: AWS using Terraform

`Components`: VPC, EKS, RDS, ECR, Jenkins, Argo CD, Prometheus, Grafana

## Prerequisites

- AWS CLI installed and configured
- kubectl installed
- Helm installed
- Docker installed
- Terraform installed

Please add `terraform.tfvars` file to the root directory of the project.

The file contents is as follows:

```sh
# required vars:
github_repo_url     # https://github.com/<github_username>/<project_name>.git
github_username     # github username
github_token        # github pat token
```

## Set up the environment

```sh
cd modules/s3-backend
terraform init
terraform apply
cd ../..
terraform init
terraform apply
```

## Deploy the application

### Push the image to the ECR

```sh
cd django
docker build --tag 033491664040.dkr.ecr.eu-central-1.amazonaws.com/vp-dja:v1.0.0 --platform linux/amd64 .
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 033491664040.dkr.ecr.eu-central-1.amazonaws.com/vp-dja
docker push 033491664040.dkr.ecr.eu-central-1.amazonaws.com/vp-dja:v1.0.0
```

### Connect kubectl to your cluster

```sh
aws eks update-kubeconfig --region eu-central-1 --name vp-dja
```

### Check the services in the cluster

```sh
kubectl get svc -A
```

The `django-app-django` is the service that hosts the project and its LoadBalancer External-IP/URL is the address for access

### Set up automatic CI

- Open Jenkins URL
- Login with username: admin; password: admin123
- Go to `Manage Jenkins` -> `System configuration | System` -> `Jenkins URL` and set it to the URL from LoadBalancer
- Go to `Manage Jenkins` -> `Security | In-process Script Approval` and approve the script from Terraform
- Run the `seed-job` job (that will create a new job `django-docker`)

To connect repository monitoring, you need to add a webhook to the github repository. **Payload URL** is the Jenkins URL of the jenkins service followed by `/github-webhook`. Content type should be set to `application/json` and SSL verification needs to be off.

Second job will monitor the webhook connections. When the webhook is triggered is will:

- Build and push the new Docker image to ECR
- Merge MR in your repo with updating the app version (according to the Jenkins `django-docker` job build number)

### Verify the CD

- `kubectl port-forward -n argocd svc/argo-cd-argocd-server 8080:80` to enable port forwarding for Argo-CD
- `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d` to get the admin password
- open URL <http://localhost:8080> and login with username `admin` and password from above
- check the status of `django-app` application (should be `Healthy` and `Synced`)

### Check performance stats

- `kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80` to enable port forwarding for Grafana
- `kubectl -n monitoring get secret kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d` to get the admin password
- open URL <http://localhost:3000> and login with username `admin` and password from above
- check existing dashboards to see the CPU and Memory usage (PODs, Nodes etc.)

## Destroy the environment

- Login to AWS
- Go to the EC2 section
- Open Load Balancers
- Delete the created Load balancers manually. They're created by Helm and are not registered in Terraform, so TF won't delete them and they and will not allow the VPC to be deleted

```sh
terraform destroy
```
