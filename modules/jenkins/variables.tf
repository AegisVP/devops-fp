variable "namespace" {
  description = "Name of the Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for IRSA"
  type        = string

}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider for IRSA"
  type        = string
}

variable "github_login" {
  description = "Github Username"
  type        = string
}

variable "github_token" {
  description = "Github PAT"
  type        = string
}

variable "github_repo" {
  description = "Github Repository URL"
  type        = string
}

variable "github_branch" {
  description = "Github Branch"
  type        = string
}
