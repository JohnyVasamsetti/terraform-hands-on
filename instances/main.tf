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

# Route tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.mumbai_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mumbai_igw.id
  }
  tags = {
    task = "instances"
    Name = "public_route_table"
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.mumbai_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mumbai_ngw.id
  }
  tags = {
    task = "instances"
    Name = "public_route_table"
  }
}

# Attaching route tables with subnets
resource "aws_route_table_association" "public_rt_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}
resource "aws_route_table_association" "private_sn_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnet.id
}