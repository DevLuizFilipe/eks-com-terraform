variable "route53_zone_name" {
  type        = string
  description = "Nome da zona DNS"
}

variable "route53_record_name" {
  type        = string
  description = "Nome do registro DNS"
}

variable "route53_record_type" {
  type        = string
  description = "Tipo do registro DNS"
}

variable "route53_record_ttl" {
  type        = number
  description = "TTL do registro DNS"
}

variable "route53_records" {
  type        = list(string)
  description = "Lista de registros DNS"
}
