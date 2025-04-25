variable "domain_name" {
  description = "The main domain name"
  type        = string
}

variable "alternative_names" {
  description = "List of alternative domain names (e.g. www.domain.com)"
  type        = list(string)
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
}
