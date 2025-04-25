############## SECONDARY REGION SETUP FOR DR ######################################

module "vpc_dr" {
  source                  = "../modules/vpc"

  vpc_cidr                = var.vpc_cidr
  cidr_private_subnet     = var.cidr_private_subnet
  cidr_public_subnet      = var.cidr_public_subnet
  vpc_name                = var.vpc_name
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

module "security_group_dr" {
  source              = "../modules/security_group"

  vpc_id              = module.vpc_dr.dr_project_vpc
  ec2_sg_name         = var.ec2_sg_name
  alb_sg_name         = var.alb_sg_name
  db_sg_name          = var.db_sg_name
  security_group_cidr = var.security_group_cidr
}


module "rds_dr" {
  source                  = "../modules/rds_replica"

  source_db_arn           = data.terraform_remote_state.primary.outputs.db_instance_arn
  db_identifier           = var.db_identifier
  db_instance_class       = var.db_instance_class
  db_security_group       = module.security_group_dr.database_security_g_name
  private_subnets         = module.vpc_dr.dr_project_private_subnets
  db_subnet_name          = var.db_subnet_name
}


module "alb_dr" {

  source             = "../modules/alb_dr"
  vpc_id             = module.vpc_dr.dr_project_vpc
  alb_sg_id          = module.security_group_dr.load_security_g_name
  public_subnets     = module.vpc_dr.dr_project_public_subnets
  project_name       = var.project_name
  acm_cert_arn       = module.acm_dr.acm_cert_arn
}

module "acm_dr" {
  source = "../modules/acm_dr"

  domain_name        = var.domain_name
  alternative_names  = var.alternative_names
}


module "launch_template_dr" {
  source = "../modules/launch_template"

  instance_name            = var.instance_name
  key_name                 = var.key_name
  security_group_ids       = [module.security_group_dr.ec2_security_g_name]
  user_data_install_docker = base64encode(file("../scripts/install_docker.sh"))

}

module "autoscaling_group_dr" {
  source = "../modules/autoscaling_group"

  instance_name            = var.instance_name
  subnet_ids               = module.vpc_dr.dr_project_public_subnets
  launch_template_id       = module.launch_template_dr.launch_template_id
  launch_template_version  = module.launch_template_dr.launch_template_version
  target_group_arns        = [module.alb_dr.target_group_arns]
}


module "route53_dr" {
  
  source = "../modules/route53"
  domain_name         = var.domain_name
  alb_dns_name        = module.alb_dr.alb_dns
  alb_zone_id         = module.alb_dr.alb_zone_id
  failover_role       = "SECONDARY"
  create_health_check = true
  health_check_fqdn   = module.alb_dr.alb_dns
  create_www          = false
}

module "monitoring_primary" {
  source = "../modules/monitoring"
  health_check_id = data.terraform_remote_state.primary.outputs.health_check_id
}


module "lambda_failover" {
  source = "../modules/lambda_failover"
  sns_topic_arn = module.monitoring_primary.sns_topic_arn
  lambda_file     = "../scripts/lambda.zip"         
  lambda_hash     = filebase64sha256("../scripts/lambda.zip")
}
