output "db_hostname" {
  value = aws_db_instance.mysql_instance.address
}

output "db_instance_arn" {
  value = aws_db_instance.mysql_instance.arn
}

output "db_instance_endpoint" {
  value = split(":", aws_db_instance.mysql_instance.endpoint)[0]
}