resource "helm_release" "kube-prometheus-stack" {
  name             = "kube-prometheus-stack"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "75.15.0"
  create_namespace = true
  timeout          = 600

  values = [
    file("${path.module}/values.yaml")
  ]
}
