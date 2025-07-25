variable "name" {
  description = "Name of the Helm release"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Version of the Argo CD chart"
  type        = string
  default     = "latest"
}

variable "github_repo" {
  description = "Github Repository URL"
  type        = string
}

variable "github_branch" {
  description = "Github Branch"
  type        = string
  default     = "main"
}

variable "db_host" {
  description = "Database host django app"
  type        = string
}

variable "db_name" {
  description = "Database name django app"
  type        = string
}

variable "db_user" {
  description = "Database user django app"
  type        = string
}

variable "db_pass" {
  description = "Database password django app"
  type        = string
}
