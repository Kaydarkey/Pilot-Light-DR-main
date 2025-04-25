variable "vpc_id" {
    type = string
}
variable "alb_sg_id" {
    type = string
}
variable "public_subnets" {
    type = list(string)
}
variable "project_name" {
    type = string
}
variable "acm_cert_arn" {
    type = string
}

variable "target_id" {
  type = string
}
