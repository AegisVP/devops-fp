# IAM-role for EKS worker nodes
resource "aws_iam_role" "nodes" {
  # Name of the role for nodes
  name = "${var.cluster_name}-eks-nodes"

  # Policy that allows EKS to assume the role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# Association of policies for EKS Worker Nodes
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

# Association of policies for Amazon VPC CNI плагіну
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

# Association of policies for reading from Amazon EC2
resource "aws_iam_role_policy_attachment" "amazon_eks_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# Creation of Node Group for EKS
resource "aws_eks_node_group" "general" {
  # Name of the EKS cluster
  cluster_name = aws_eks_cluster.eks.name

  # Name of the node group
  node_group_name = "general"

  # IAM-role for nodes
  node_role_arn = aws_iam_role.nodes.arn

  # Subnets where EKS nodes will be deployed
  subnet_ids = var.subnet_ids

  # Type of EKS instances for nodes
  capacity_type  = "ON_DEMAND"
  instance_types = ["${var.instance_type}"]

  # Scaling configuration
  scaling_config {
    desired_size = var.desired_size # Desired number of nodes
    max_size     = var.max_size     # Maximum number of nodes
    min_size     = var.min_size     # Minimum number of nodes
  }

  # Node update configuration
  update_config {
    max_unavailable = 2 # Maximum number of nodes that can be updated simultaneously
  }

  # Adds labels to nodes
  labels = {
    role = "general" # Tag "role" with value "general"
  }

  # Dependencies for creating Node Group
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_eks_container_registry_read_only,
  ]

  # Ignores changes in desired_size to avoid conflicts
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
