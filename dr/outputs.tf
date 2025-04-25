output "vpc_id" {
  value = module.vpc_dr.dr_project_vpc
}

output "public_subnets" {
  value = module.vpc_dr.dr_project_public_subnets
}

output "private_subnets" {
  value = module.vpc_dr.dr_project_private_subnets
}

output "alb_sg_name" {
  value = module.security_group_dr.load_security_g_name
}

output "ec2_sg_name" {
  value = module.security_group_dr.ec2_security_g_name
}

output "database_sg_name" {
  value = module.security_group_dr.database_security_g_name
}

# output "db_hostname" {
#   value = module.rds_p.db_hostname

# }

output "alb_dns_name" {
  value = module.alb_dr.alb_dns
}
output "health_check_id" {
  value = data.terraform_remote_state.primary.outputs.health_check_id
}

# output "ec2_public_ip_address" {
#   value = module.ec2_primary.terra_demo_proj_ec2_instance

# }