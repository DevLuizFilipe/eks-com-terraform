variable "ingress_name" {
  type        = string
  description = "Nome do ingress"
}

variable "ingress_namespace" {
  type        = string
  description = "Namespace do ingress"
}

variable "ingress_host" {
  type        = string
  description = "Host do ingress"
}

variable "ingress_path" {
  type        = string
  description = "Path do ingress"
}

variable "ingress_backend_service_name" {
  type        = string
  description = "Nome do service a ser direcionado"
}

variable "ingress_backend_service_port" {
  type        = string
  description = "Porta do service a ser direcionado"
}
