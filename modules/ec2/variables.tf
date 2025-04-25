variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name to SSH into EC2"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address"
  type        = bool
  default     = true
}
variable "user_data_install_docker" {

}
