output "s3_bucket_name" {
  description = "Name of the S3 bucket for state files"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "s3_bucket_url" {
  description = "URL of the S3 bucket for state files"
  value       = aws_s3_bucket.terraform_state.bucket_regional_domain_name
}
