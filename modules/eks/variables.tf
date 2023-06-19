variable "eks_name" {
  type        = string
  description = "Nome do Cluster EKS"
}

variable "eks_role_arn" {
  type        = string
  description = "ARN da role"
}

variable "eks_subnets_id" {
  type        = list(string)
  description = "ID das subnets"
}

variable "eks_security_group_id" {
  type        = list(string)
  description = "ID do Security Group"
}

variable "eks_enviroment_tag" {
  type        = string
  description = "Tag de ambiente"
}

variable "eks_node_group_name" {
  type        = string
  description = "Nome do Node Group"
}

variable "eks_node_group_role_arn" {
  type        = string
  description = "ARN da role do Node Group"
}

variable "eks_nodegroup_desired_instance" {
  type        = string
  description = "Quantidade de instancias desejadas"
}

variable "eks_nodegroup_max_instance" {
  type        = string
  description = "Quantidade maxima de instancias"
}

variable "eks_nodegroup_min_instance" {
  type        = string
  description = "Quantidade minima de instancias"
}

variable "eks_nodegroup_instance_type" {
  type        = list(string)
  description = "Tipo de instancia"
}

variable "eks_nodegroup_instance_disk" {
  type        = string
  description = "Tamanho do disco em GB"
}
