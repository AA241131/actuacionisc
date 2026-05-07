resource "aws_vpc" "vpc-ac1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc-ac1"
  }
}

resource "aws_subnet" "ac1-private-subnet" {
  vpc_id                  = aws_vpc.vpc-ac1.id
  cidr_block              = var.private_subnet
  availability_zone       = var.vpc_aws_az
  map_public_ip_on_launch = "false"
  tags = {
    Name = "terraform-ac1-private-subnet"
  }
}
resource "aws_subnet" "ac1-private-subnet-2" {
  vpc_id                  = aws_vpc.vpc-ac1.id
  cidr_block              = var.private_subnet-2
  availability_zone       = var.vpc_aws_az-2
  map_public_ip_on_launch = "false"
  tags = {
    Name = "terraform-ac1-private-subnet-2"
  }
}
resource "aws_internet_gateway" "ac1-gw" {
  vpc_id = aws_vpc.vpc-ac1.id
  tags = {
    Name = "terraform-ac1-gw"
  }
}

resource "aws_route_table" "ac1_route_table" {
  vpc_id = aws_vpc.vpc-ac1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ac1-gw.id
  }
  tags = {
    Name = "custom route table"
  }
}