resource "aws_iam_role" "ec2_secrets_access" {
  name = "${var.instance_name}-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "secrets_read_policy" {
  name = "${var.instance_name}-secrets-read-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_secrets_access.name
  policy_arn = aws_iam_policy.secrets_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.ec2_secrets_access.name
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_launch_template" "ec2_template" {
  name_prefix   = "${var.instance_name}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = var.security_group_ids

  user_data = var.user_data_install_docker
  # network_interfaces {
  #   associate_public_ip_address = true
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}
