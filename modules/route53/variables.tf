variable "domain_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "failover_role" {
  type    = string
  default = "PRIMARY" 
}

variable "create_health_check" {
  type    = bool
  default = true
}

variable "health_check_fqdn" {
  type    = string
  default = ""
}

variable "create_www" {
  type    = bool
  default = true
}
