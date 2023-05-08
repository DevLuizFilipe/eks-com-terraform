resource "kubernetes_service" "service" {
  metadata {
    name      = var.service_name
    namespace = var.service_namespace
  }
  spec {
    selector = {
      app = var.service_selector
    }
    type = var.service_type
    port {
      protocol    = var.service_protocol
      port        = var.service_port
      target_port = var.service_target_port
    }
  }
}
