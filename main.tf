provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "vpc_tf" {
  cidr_block           = var.vpc_id
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }

}
resource "aws_subnet" "vpc-subnet" {
  count                   = length(var.public_subnet)
  cidr_block              = element(var.public_subnet, count.index)
  vpc_id                  = aws_vpc.vpc_tf.id
  availability_zone       = element(var.az, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-publicsubnet-${count.index + 1}"
  }

}
resource "aws_route_table" "vpc_route" {
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "${var.vpc_name}-routetable"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
}
resource "aws_route_table_association" "vpc_route_association" {
  count          = length(var.public_subnet)
  subnet_id      = element(aws_subnet.vpc-subnet.*.id, count.index)
  route_table_id = aws_route_table.vpc_route.id
}
resource "aws_security_group" "allow_all" {
  name        = "Dev-B7-sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.vpc_tf.id

  ingress {
    description = "ALL TRAFFIC from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "MEGA-SG"
  }
}