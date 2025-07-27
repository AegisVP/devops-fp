output "admin_password" {
  description = "Argo CD initial admin password"
  value       = "Run: kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
}
