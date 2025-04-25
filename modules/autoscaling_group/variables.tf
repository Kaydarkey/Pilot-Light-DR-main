variable "instance_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "launch_template_id" {
  type = string
}

variable "launch_template_version" {
  type = string
}
variable "target_group_arns" {
  type    = list(string)
  default = []
}
