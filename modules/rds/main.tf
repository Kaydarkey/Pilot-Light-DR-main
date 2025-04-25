resource "aws_db_subnet_group" "db_subnet" {
  name       = var.db_subnet_name
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "mysql_instance" {
  allocated_storage       = 10
  storage_type            = var.storage_type
  engine                  = var.db_engine
  instance_class          = var.db_instance_class
  identifier              = var.db_identifier
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = [var.db_security_group]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet.name
  db_name                 = var.db_name
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 7
  deletion_protection     = false
}
