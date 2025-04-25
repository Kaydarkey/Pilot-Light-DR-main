resource "aws_db_subnet_group" "db_subnet" {
  name       = var.db_subnet_name
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "replica" {
  replicate_source_db     = var.source_db_arn
  instance_class          = var.db_instance_class
  identifier              = "${var.db_identifier}-replica"
  db_subnet_group_name    = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids  = [var.db_security_group]
  skip_final_snapshot     = true
}
