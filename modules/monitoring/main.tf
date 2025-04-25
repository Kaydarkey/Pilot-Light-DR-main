resource "aws_sns_topic" "failover_topic" {
  name = "failover-alert-topic"
}

resource "aws_cloudwatch_metric_alarm" "r53_health_check_alarm" {
  alarm_name          = "primary-site-unhealthy"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 30
  statistic           = "Minimum"
  threshold           = 1
  alarm_description   = "Triggers if primary Route53 health check fails"
  actions_enabled     = true

  dimensions = {
    HealthCheckId = var.health_check_id
  }

  alarm_actions = [aws_sns_topic.failover_topic.arn]
}
