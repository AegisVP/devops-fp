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
- [Monitoring](#monitoring)
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
- Key pair for SSH authentication created and imported to AWS

Please add `terraform.tfvars` file to the root directory of the project.

The file contents is as follows:

```hcl
# required vars:
github_repo_url     # https://github.com/<github_username>/<project_name>.git
github_username     # github username
github_token        # github pat token
ssh_key_name        # name of the Key Pair in AWS (AWS -> EC2 -> Key Pairs)

# optional vars (<variable> = <default_value>):
aws_region          = "eu-central-1"
s3_bucket_name      = "goit-devops-fp-terraform-state"
dynamodb_table_name = "terraform-locks"
ecr_repository_name = "vp-dja"
github_branch       = "main"
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

Now that the environment is set up, you can proceed with the rest of the tasks.

Connect kubectl to your cluster:

```sh
aws eks update-kubeconfig --region eu-central-1 --name <your_cluster_name>
```

Check the services in the cluster:

```sh
kubectl get svc -A
```

URL to created resources can be found in LoadBalancer URL.

Open Jenkins LoadBalancer URL (username: admin; password: admin123)

- Run the `seed-job` job (that will create new job `django-docker`)
- Run the `django-docker` job

Second job will:

- Build and push Docker image to ECR
- Merge MR in your repo with updating the app version (according to the Jenkins `django-docker` job build number)

Open Argo CD LoadBalancer URL

- check the status of `django-app` application (should be `Healthy` and `Synced`)

## Monitoring

- forward Grafana port using the next command
- - `kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80`
- open URL <http://localhost:3000>
- login with username `admin` and password from the next command
- - `kubectl get secret --namespace monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode`
- check existing dashboards to see the CPU and Memory usage (PODs, Nodes etc.)

## Destroy the environment

```sh
terraform destroy
```
