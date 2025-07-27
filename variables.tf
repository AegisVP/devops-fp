variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-central-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
  default     = "vp-dja-terraform-state-bucket"

}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform locks"
  type        = string
  default     = "terraform-locks"
}

variable "name" {
  description = "The name of the project"
  type        = string
  default     = "vp-dja"
}

variable "instance_type" {
  description = "EC2 instance type for the worker nodes"
  type        = string
  default     = "t3.medium"
}


variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_login" {
  description = "GitHub username"
  type        = string
  default     = "AegisVP"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "github.com/AegisVP/devops-fp.git"
}

variable "github_branch" {
  description = "GitHub branch for Jenkins"
  type        = string
  default     = "main"
}


variable "rds_use_aurora" {
  description = "Use Aurora for the RDS database"
  type        = bool
  default     = false
}

variable "rds_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "postgres"
}

variable "rds_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}

variable "rds_database_name" {
  description = "Name of the RDS database"
  type        = string
  default     = "django"
}
