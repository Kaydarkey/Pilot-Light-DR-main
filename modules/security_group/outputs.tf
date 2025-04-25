output "load_security_g_name" {
  value = aws_security_group.alb_sg.id

}

output "ec2_security_g_name" {
  value = aws_security_group.ec2_sg.id

}

output "database_security_g_name" {
  value = aws_security_group.db_sg.id

}