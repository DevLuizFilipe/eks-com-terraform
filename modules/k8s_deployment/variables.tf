variable "deployment_name" {
  type        = string
  description = "Nome do deployment do Kubernetes"
}

variable "deployment_namespace" {
  type        = string
  description = "Namespace do deployment"
}

variable "deployment_replicas" {
  type        = string
  description = "Quantidade de pods do deployment"
}

variable "deployment_container_name" {
  type        = string
  description = "Nome do container"
}

variable "deployment_container_image_name" {
  type        = string
  description = "Nome da imagem Docker para o container"
}

variable "deployment_container_image_tag" {
  type        = string
  description = "Tag da imagem Docker para o container"
}

variable "deployment_container_port" {
  type        = number
  description = "Porta do container"
}

variable "deployment_secret_name" {
  type        = string
  description = "Nome do secret que contém as variáveis de ambiente"
}

variable "deployment_prometheus_monitore" {
  type        = string
  description = "Habilitar monitoramento do prometheus"
}

variable "deployment_prometheus_port" {
  type        = string
  description = "Porta do path a ser monitorado"
}

variable "deployment_prometheus_path" {
  type        = string
  description = "Path do target a ser monitorado"
}
