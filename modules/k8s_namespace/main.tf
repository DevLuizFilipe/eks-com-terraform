resource "kubernetes_namespace" "kube_news" {
  metadata {
    name = var.namespace_name
  }
}