resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "${var.instance_name}-asg"
  desired_capacity          = 0
  max_size                  = 2
  min_size                  = 0
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns = var.target_group_arns
  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
