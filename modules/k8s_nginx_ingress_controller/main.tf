resource "helm_release" "nginx_ingress_controller" {
  name       = var.nginx_ingress_controller_name
  repository = var.nginx_ingress_controller_repository
  chart      = var.nginx_ingress_controller_chart
  namespace  = var.nginx_ingress_controller_namespace

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "rbac.serviceAccountName"
    value = var.nginx_ingress_controller_name
  }

  set {
    name  = "controller.ingressClass"
    value = "nginx"
  }
}

resource "kubernetes_service_account" "service_account" {
  metadata {
    name      = var.nginx_ingress_controller_name
    namespace = var.nginx_ingress_controller_namespace
  }
}

resource "kubernetes_cluster_role_binding" "role_binding" {
  metadata {
    name = var.nginx_ingress_controller_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.service_account.metadata[0].name
    namespace = var.nginx_ingress_controller_namespace
  }
}
