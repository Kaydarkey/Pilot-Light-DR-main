variable "instance_name" {
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "user_data_install_docker" {
  type = string
}
