#################  VPC  ###################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

#################  ECR  ###################

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_repository_arn" {
  value = module.ecr.repository_arn
}

#################  RDS  ###################

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

#################  EKS  ###################

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_node_role_arn" {
  value = module.eks.eks_node_role_arn
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider_url
}

#################  Jenkins  ###################

output "jenkins_release" {
  value = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  value = module.jenkins.jenkins_namespace
}

output "github_user" {
  value = var.github_login
}

#################  ArgoCD  ###################

output "argocd_admin_password" {
  value = module.argo-cd.admin_password
}
