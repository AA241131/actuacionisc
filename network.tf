resource "aws_vpc" "vpc-ac2" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc-ac2"
  }
}

resource "aws_subnet" "ac2-private-subnet" {
  vpc_id                  = aws_vpc.vpc-ac2.id
  cidr_block              = var.public_subnet-1
  availability_zone       = var.vpc_aws_az-1
  map_public_ip_on_launch = "true"
  tags = {
    Name = "terraform-ac2-public-subnet-1"
  }
}
resource "aws_subnet" "ac2-public-subnet" {
  vpc_id                  = aws_vpc.vpc-ac2.id
  cidr_block              = var.public_subnet-2
  availability_zone       = var.vpc_aws_az-2
  map_public_ip_on_launch = "true"
  tags = {
    Name = "terraform-ac2-public-subnet-2"
  }
}
resource "aws_internet_gateway" "ac2-igw" {
  vpc_id = aws_vpc.vpc-ac2.id
  tags = {
    Name = "terraform-ac2-igw"
  }
}

resource "aws_route_table" "ac2_route_table" {
  vpc_id = aws_vpc.vpc-ac2.id
  route {
    cidr_block = "0.0.0.0/0"  
    gateway_id = aws_internet_gateway.ac2-igw.id
  }
  tags = {
    Name = "terraform-ac2-route-table"
  }
}

#route table por defecto
resource "aws_main_route_table_association" "ac2-main-association" {
  vpc_id         = aws_vpc.vpc-ac2.id
  route_table_id = aws_route_table.ac2_route_table.id
}