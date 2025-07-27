output "repository_url" {
  description = "URL of the created ECR"
  value       = aws_ecr_repository.ecr_repository.repository_url
}

output "repository_arn" {
  description = "ARN of the created ECR"
  value       = aws_ecr_repository.ecr_repository.arn
}
