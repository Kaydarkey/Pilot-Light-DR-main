variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type = string
}

variable "cidr_public_subnet" {
  type = list(string)
}

variable "cidr_private_subnet" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_name" {
  type = string
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}


variable "alb_sg_name" {
  type = string

}

variable "ec2_sg_name" {
  type = string

}

variable "db_sg_name" {
  type = string

}

variable "security_group_cidr" {
  type = string
}

variable "db_username" {
  type = string

}

variable "db_password" {
  type = string

}
variable "db_name" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_identifier" {
  type = string
}

variable "db_subnet_name" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "alternative_names" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}
