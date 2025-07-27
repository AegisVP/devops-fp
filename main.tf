terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

data "aws_eks_cluster" "eks" {
  name       = module.eks.eks_cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name       = module.eks.eks_cluster_name
  depends_on = [module.eks]
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# Creating ECR
module "ecr" {
  source           = "./modules/ecr"
  ecr_name         = var.name
  ecr_mutable      = true
  scan_on_push     = true
  ecr_force_delete = true
}

# Creating VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_name           = "${var.name}-vpc"
  depends_on         = [module.ecr] # Ensure ECR is created before VPC and everything else will be deleted before ECR fails to delete last
}

module "rds" {
  source     = "./modules/rds"
  name       = "${var.name}-rds"
  use_aurora = false

  # --- Aurora-only ---
  aurora_instance_count         = 2
  engine_cluster                = "aurora-postgresql"
  engine_version_cluster        = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  db_name                 = var.rds_database_name
  username                = var.rds_username
  password                = var.rds_password
  subnet_private_ids      = module.vpc.private_subnets
  subnet_public_ids       = module.vpc.public_subnets
  publicly_accessible     = true
  vpc_id                  = module.vpc.vpc_id
  multi_az                = true
  backup_retention_period = 7
  depends_on              = [module.vpc]
  parameters = {
    max_connections            = "200"
    log_min_duration_statement = "500"
  }

  tags = {
    Environment = "dev"
    Project     = var.name
  }
}

# Creating EKS
module "eks" {
  source        = "./modules/eks"
  cluster_name  = "eks-vp"
  subnet_ids    = module.vpc.public_subnets
  instance_type = "t3.medium"
  desired_size  = 2
  max_size      = 6
  min_size      = 2
  depends_on    = [module.rds]
}

module "monitoring" {
  source     = "./modules/monitoring"
  depends_on = [module.eks]
}

# Creating Jenkins
module "jenkins" {
  source            = "./modules/jenkins"
  cluster_name      = module.eks.eks_cluster_name
  namespace         = "jenkins"
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  github_login      = var.github_login
  github_token      = var.github_token
  github_repo       = var.github_repo
  github_branch     = var.github_branch
  depends_on        = [module.eks]
}

# Creating Argo-CD
module "argo-cd" {
  source        = "./modules/argo-cd"
  namespace     = "argocd"
  chart_version = "8.1.3"
  github_repo   = var.github_repo
  github_branch = var.github_branch
  depends_on    = [module.eks]
  db_host       = module.rds.rds_endpoint
  db_name       = var.rds_database_name
  db_user       = var.rds_username
  db_pass       = var.rds_password
}
