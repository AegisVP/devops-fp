resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argo_cd" {
  name             = "${var.name}-argocd"
  namespace        = var.namespace
  replace          = true
  force_update     = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  values           = [file("${path.module}/values.yaml")]
  depends_on       = [kubernetes_namespace.argo_cd]
  create_namespace = false
  timeout          = 600
}

locals {
  argocd_values = templatefile("${path.module}/charts/values.tpl", {
    github_repo   = var.github_repo
    github_branch = var.github_branch
    db_host       = var.db_host
    db_name       = var.db_name
    db_user       = var.db_user
    db_pass       = var.db_pass
  })
}

resource "helm_release" "argo_apps" {
  name             = "${var.name}-app"
  chart            = "${path.module}/charts"
  namespace        = var.namespace
  create_namespace = false
  values           = [local.argocd_values]
  depends_on       = [helm_release.argo_cd]
}
