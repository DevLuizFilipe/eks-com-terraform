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

        annotations = {
          "prometheus.io/scrape" = var.deployment_prometheus_monitore
          "prometheus.io/port"   = var.deployment_prometheus_port
          "prometheus.io/path"   = var.deployment_prometheus_path
        }
      }

      spec {
        container {
          name  = var.deployment_container_name
          image = "${var.deployment_container_image_name}:${var.deployment_container_image_tag}"
          port {
            container_port = var.deployment_container_port
          }

          env_from {
            secret_ref {
              name = var.deployment_secret_name
            }
          }
        }
      }
    }
  }
}
