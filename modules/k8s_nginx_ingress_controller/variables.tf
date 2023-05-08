variable "nginx_ingress_controller_name" {
  type        = string
  description = "Nome do ingress controller"
}

variable "nginx_ingress_controller_namespace" {
  type        = string
  description = "Namespace do ingress controller"
}

variable "nginx_ingress_controller_repository" {
  type        = string
  description = "Repositório do chart do ingress controller"
}

variable "nginx_ingress_controller_chart" {
  type        = string
  description = "Chart do ingress controller"
}
