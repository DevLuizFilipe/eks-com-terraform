variable "service_name" {
  type        = string
  description = "Nome do service do Kubernetes"
}

variable "service_namespace" {
  type        = string
  description = "Namespace do service do Kubernetes"
}

variable "service_selector" {
  type        = string
  description = "Selector do service do Kubernetes"
}

variable "service_type" {
  type        = string
  description = "Tipo do service do Kubernetes"
}

variable "service_protocol" {
  type        = string
  description = "Protocolo do service do Kubernetes"
}

variable "service_port" {
  type        = string
  description = "Porta do service do Kubernetes"
}

variable "service_target_port" {
  type        = string
  description = "Porta de destino do service do Kubernetes"
}
