variable "domain_name" {
  description = "The main domain name"
  type        = string
}

variable "alternative_names" {
  description = "List of alternative domain names (e.g. www.domain.com)"
  type        = list(string)
}

