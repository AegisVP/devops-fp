# IAM-role for EKS-cluster
resource "aws_iam_role" "eks" {
  # Name of the IAM-role for EKS cluster
  name = "${var.cluster_name}-eks-cluster"

  # Policy that allows EKS service to assume this IAM-role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# Association of IAM-role with AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "eks" {
  # ARN of the policy that provides permissions for EKS cluster
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  # IAM-role to which the policy is attached
  role = aws_iam_role.eks.name
}

# Creation of EKS-cluster
resource "aws_eks_cluster" "eks" {
  # Name of the cluster
  name = var.cluster_name

  # ARN of the IAM-role required for managing the cluster
  role_arn = aws_iam_role.eks.arn

  # Network configuration (VPC)
  vpc_config {
    endpoint_private_access = true           # Enables private access to the API server
    endpoint_public_access  = true           # Enables public access to the API server
    subnet_ids              = var.subnet_ids # List of subnets where EKS will operate
  }

  # Access configuration for EKS-cluster
  access_config {
    authentication_mode                         = "API" # Authentication via API
    bootstrap_cluster_creator_admin_permissions = true  # Grants admin rights to the user who created the cluster
  }

  # Dependency on IAM policy for EKS role
  depends_on = [aws_iam_role_policy_attachment.eks]
}

data "aws_caller_identity" "current" {}

resource "aws_eks_access_policy_association" "admin_policy" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
