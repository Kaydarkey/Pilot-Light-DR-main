output "alb_dns" {
  value = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.app_alb.zone_id
}