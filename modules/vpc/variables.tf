variable "vpc_cidr" {
  type        = string
  description = "VPC cidr block"
}

variable "vpc_name" {
  type        = string
  description = "Name of the vpc"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "cidr range for public subnet"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "cidr range for private subnet"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for the subnet"
}

variable "map_public_ip_on_launch" {
  type = bool
}
