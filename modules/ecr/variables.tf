variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "vp-dja"
}

variable "ecr_mutable" {
  description = "Enables or disables mutability of container tags"
  type        = bool
  default     = true
}

variable "scan_on_push" {
  description = "Enables or disables scanning on push"
  type        = bool
  default     = true
}

variable "ecr_force_delete" {
  description = "Allows deleting the repository with all images"
  type        = bool
  default     = true
}
