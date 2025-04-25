output "launch_template_id" {
  value = aws_launch_template.ec2_template.id
}

output "launch_template_version" {
  value = aws_launch_template.ec2_template.latest_version
}
