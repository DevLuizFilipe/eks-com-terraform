output "service_name" {
  value = var.service_name
}

output "service_port" {
  value = var.service_port
}

output "service_endpoint" {
  value = kubernetes_service.service.status.0.load_balancer.0.ingress.0.ip
}
