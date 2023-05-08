variable "vpc_name" {
  type        = string
  description = "Nome da VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "default 10.0.0.0/16"
}

variable "vpc_subnet1_cidr_block" {
  type        = string
  description = "CIDR da subnet"
}

variable "vpc_subnet2_cidr_block" {
  type        = string
  description = "CIDR da subnet"
}

variable "vpc_subnet_region1" {
  type        = string
  description = "Região da subnet"
}

variable "vpc_subnet_region2" {
  type        = string
  description = "Regiao da subnet"
}

variable "vpc_route_table_cidr_block" {
  type        = string
  description = "CIDR da tabela de rota"
}

variable "vpc_subnet3_cidr_block" {
  type        = string
  description = "CIDR da subnet"
}

variable "vpc_subnet_region3" {
  type        = string
  description = "Regiao da subnet"
}
