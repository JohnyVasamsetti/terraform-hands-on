# test public instance to check the availability of private instance
# key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "instance_key" {
  key_name   = "instance_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
resource "aws_secretsmanager_secret" "key_pair_secret" {
  name = "key_pair_secret"
}
resource "aws_secretsmanager_secret_version" "instance_key_version" {
  secret_string = tls_private_key.ssh_key.private_key_pem
  secret_id     = aws_secretsmanager_secret.key_pair_secret.id
}

resource "aws_security_group" "public_instance_sg" {
  name   = "public_instance_sg"
  vpc_id = aws_vpc.virginia_vpc.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    task = "ALB"
    Name = "public_instance_sg"
  }
}

resource "aws_instance" "public_instance" {
  ami             = local.ami_id
  instance_type   = local.instance_type
  subnet_id       = aws_subnet.public_subnet.id
  user_data       = file("user_data.sh")
  security_groups = [aws_security_group.public_instance_sg.id]
  key_name = aws_key_pair.instance_key.key_name
  tags = {
    task = "ALB"
    Name = "public_instance"
  }
}