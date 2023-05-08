resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = var.ingress_name
    namespace = var.ingress_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "kubernetes.io/ingress.class"                = "nginx"
    }
  }
  spec {
    rule {
      host = var.ingress_host

      http {
        path {
          path = var.ingress_path
          backend {
            service {
              name = var.ingress_backend_service_name
              port {
                number = var.ingress_backend_service_port
              }
            }
          }
        }
      }
    }
  }
}
