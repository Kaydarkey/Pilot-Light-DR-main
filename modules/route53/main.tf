data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_health_check" "alb" {
  count = var.create_health_check ? 1 : 0

  fqdn              = var.health_check_fqdn
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "${var.failover_role}-health-check"
  }
}

resource "aws_route53_record" "failover_root" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = var.failover_role
  }
  
  set_identifier     = "${var.failover_role}-alb"
  health_check_id    = var.create_health_check ? aws_route53_health_check.alb[0].id : null
}

resource "aws_route53_record" "www" {
  count   = var.create_www ? 1 : 0
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain_name]
}


