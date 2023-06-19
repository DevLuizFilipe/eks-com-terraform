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
