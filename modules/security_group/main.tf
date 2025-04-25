# create alb security group
resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Enable https and http on Port (80 and 443)"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.alb_sg_name
  }
}

# create ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_http_alb" {
  description       = "Allow remote HTTP from anywhere"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.security_group_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "Security Groups to allow HTTP(80)"
  }
}
# create ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_https_alb" {
  description       = "Allow remote HTTPS from anywhere"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.security_group_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "Security Groups to allow HTTPS(443)"
  }
}

# create egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.security_group_cidr
  ip_protocol       = "-1"

  tags = {
    Name = "Allow all outbound"
  }
}

################################
# create ec2 security group
resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_sg_name
  description = "Enable https from alb security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.ec2_sg_name
  }
}

# create ingress rule
resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_rule" {
  description       = "Allow  HTTPS from alb"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.security_group_cidr

  # referenced_security_group_id = aws_security_group.alb_sg.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = var.ec2_sg_name
  }
}
# create ingress rule
resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_rule1" {
  description       = "Allow  HTTP from alb"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.security_group_cidr

  # referenced_security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = var.ec2_sg_name
  }
}

# create ingress rule
resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_rule2" {
  description       = "Allow  HTTP from alb"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.security_group_cidr

  # referenced_security_group_id = aws_security_group.alb_sg.id
  from_port         = 8081
  ip_protocol       = "tcp"
  to_port           = 8081

  tags = {
    Name = var.ec2_sg_name
  }
}



# create ingress rule
resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_rule_2" {
  description       = "Allow remote SSH from anywhere"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.security_group_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "Security Groups to allow SSH(22)"
  }
}

# create egress rule
resource "aws_vpc_security_group_egress_rule" "ec2_sg_egress_rule" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.security_group_cidr
  ip_protocol       = "-1"

  tags = {
    Name = "Allow all outbound"
  }
}
#############################################################
# create database security group
resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Enable 5432 from ec2 security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.db_sg_name
  }
}


resource "aws_vpc_security_group_ingress_rule" "db_sg_ingress_rule" {
  description       = "Allow  HTTPS from alb"
  security_group_id = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306

  tags = {
    Name = var.db_sg_name
  }
}

# create egress rule
resource "aws_vpc_security_group_egress_rule" "db_sg_egress_rule" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = var.security_group_cidr
  ip_protocol       = "-1"

  tags = {
    Name = "Allow all outbound"
  }
}