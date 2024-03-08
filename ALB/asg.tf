resource "aws_launch_template" "launch_template" {
  name_prefix = "launch-instance-"
  image_id      = local.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
}

resource "aws_autoscaling_group" "auto_scaling" {
  name = "auto-scale-application"
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.private_subnet.id,aws_subnet.private_subnet_2.id]

  launch_template {
    id      = aws_launch_template.launch_template.id
  }
}

output "private_sg" {
  value = aws_security_group.private_instance_sg.id
}