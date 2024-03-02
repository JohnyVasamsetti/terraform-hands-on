resource "aws_vpc" "mumbai_vpc" {
  cidr_block = local.mumbai_vpc_cidr_block
  tags = {
    task = "instances"
    Name = "mumbai_vpc"
  }
}

# Gateways
resource "aws_internet_gateway" "mumbai_igw" {
  vpc_id = aws_vpc.mumbai_vpc.id
  tags = {
    task = "instances"
    Name = "mumbai_igw"
  }
}
resource "aws_eip" "public_eip" {
  domain = "vpc"
  tags = {
    task = "instances"
    Name = "public_eip"
  }
}
resource "aws_nat_gateway" "mumbai_ngw" {
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.public_eip.id
  tags = {
    task = "instances"
    Name = "mumbai_ngw"
  }
}

# Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.mumbai_vpc.id
  cidr_block = local.public_subnet_cidr_block
  availability_zone = "ap-south-1a"
  tags = {
    task = "instances"
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.mumbai_vpc.id
  cidr_block = local.private_subnet_cidr_block
  tags = {
    task = "instances"
    Name = "private_subnet"
  }
}
