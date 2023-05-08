variable "secret_name_kube_news" {
  type        = string
  description = "Nome do secret do Kubernetes Kube-News"
}

variable "secret_name_postgres" {
  type        = string
  description = "Nome do secret do Kubernetes Postgres"
}

variable "secret_namespace" {
  type        = string
  description = "Namespace do secret do Kubernetes"
}
