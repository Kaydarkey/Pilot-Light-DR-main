variable "db_subnet_name" {
  type = string
  description = "Name of db subnet"
}

variable "private_subnets" {
  type = list(string)
  description = "list of subnets"
}
variable "db_identifier" {
  type = string
  description = "name of db identifier"
}

variable "db_name" {
  type = string
  description = "name of database"
}
variable "db_password" {
  type = string
  description = "password for database"
}

variable "db_username" {
  type = string
  description = "username for database"
}

variable "db_engine" {
  type = string
  description = "database engine"
}

variable "storage_type" {
  type = string
  description = "storage type"
}

variable "db_instance_class" {
  type = string
  description = "database instance type"
}

variable "db_security_group" {
  type = string
  description = "security for database"
}

variable "replicate_from_primary" {
  description = "Set to true if this is a replica RDS"
  type        = bool
  default     = false
}

variable "source_db_arn" {
  description = "ARN of the source DB to replicate from"
  type        = string
  default     = ""
}
