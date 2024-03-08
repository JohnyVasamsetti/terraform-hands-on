resource "aws_lb" "alb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet.id,aws_subnet.public_subnet_2.id]

  enable_deletion_protection = true
  tags = {
    task = "ALB"
    Name = "ALB"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.virginia_vpc.id
}

resource "aws_autoscaling_attachment" "tg_to_asg" {
  autoscaling_group_name = aws_autoscaling_group.auto_scaling.name
  lb_target_group_arn = aws_lb_target_group.alb_tg.arn
}


resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = aws_vpc.virginia_vpc.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.private_subnet_cidr_block,local.private_subnet_cidr_block_2]
  }
  tags = {
    task = "ALB"
    Name = "alb_sg"
  }
}