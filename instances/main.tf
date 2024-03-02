resource "aws_vpc" "mumbai_vpc" {
  cidr_block = local.mumbai_vpc_cidr_block
  tags = {
    task = "instances"
    Name = "mumbai_vpc"
  }
}

resource "aws_internet_gateway" "mumbai_igw" {
  vpc_id = aws_vpc.mumbai_vpc.id
  tags = {
    Name = "mumbai_igw"
  }
}

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
