variable "newrelic_agent_name" {
  type        = string
  description = "Nome do chart no Helm"
}

variable "newrelic_agent_repository" {
  type        = string
  description = "Repositório do chart no Helm"
}

variable "newrelic_agent_chart" {
  type        = string
  description = "Nome do chart do Helm"
}

variable "newrelic_agent_namespace" {
  type        = string
  description = "Namespace do chart no Cluster"
}

variable "newrelic_agent_license_key" {
  type        = string
  description = "Chave de licença do New Relic"
}

variable "newrelic_agent_cluster" {
  type        = string
  description = "Nome do cluster"
}

variable "newrelic_agent_image_tag" {
  type        = string
  description = "Tag da imagem do New Relic"
}

variable "newrelic_agent_pixie_api_key" {
  type        = string
  description = "Chave de API do Pixie"
}

variable "newrelic_agent_pixie_deploy_key" {
  type        = string
  description = "Chave de deploy do Pixie"
}

variable "newrelic_agent_pixie_cluster_name" {
  type        = string
  description = "Nome do cluster"
}
