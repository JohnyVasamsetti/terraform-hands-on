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

resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = aws_vpc.virginia_vpc.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
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