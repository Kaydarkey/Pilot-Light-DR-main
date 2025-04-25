output "dr_project_vpc" {
  value = aws_vpc.dr_project_vpc.id

}

output "dr_project_public_subnets" {
  value = aws_subnet.dr_project_public_subnet.*.id
}

output "dr_project_private_subnets" {
  value = aws_subnet.dr_project_private_subnet.*.id
}