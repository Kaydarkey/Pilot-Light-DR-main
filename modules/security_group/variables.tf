variable "vpc_id" {
  type    = string
  default = "vpc id"
}

variable "alb_sg_name" {
  type        = string
  description = "name of the security group load balancer"
}

variable "ec2_sg_name" {
  type        = string
  description = "name of the security group ec2"
}

variable "db_sg_name" {
  type        = string
  description = "name of the security group database"
}


variable "security_group_cidr" {
  type        = string
  description = "cidr for the security group alb"
}