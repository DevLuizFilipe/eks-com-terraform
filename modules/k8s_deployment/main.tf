resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = var.deployment_name
    namespace = var.deployment_namespace
  }

  spec {
    replicas = var.deployment_replicas

    selector {
      match_labels = {
        app = var.deployment_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.deployment_name
        }
      }

      spec {
        container {
          name  = var.deployment_container_name
          image = "${var.deployment_container_image_name}:${var.deployment_container_image_tag}"
          port {
            container_port = var.deployment_container_port
          }
        }
      }
    }
  }
}
