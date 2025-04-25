output "alb_dns" {
  value = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.app_alb.zone_id
}

output "target_group_arns" {
  value = aws_lb_target_group.app_tg.arn
}