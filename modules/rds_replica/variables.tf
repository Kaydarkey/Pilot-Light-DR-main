variable "source_db_arn" {}
variable "db_identifier" {}
variable "db_instance_class" {}
variable "db_subnet_name" {}
variable "private_subnets" {
  type = list(string)
}
variable "db_security_group" {}
