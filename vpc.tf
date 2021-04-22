provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAUAEJVWASGNN6YN4D"
  secret_key = "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"
}

resource "aws_vpc" "VPC" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_subnet" "Public_Subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "Public_Subnet"
  }
}
resource "aws_subnet" "Private_subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "192.168.3.0/24"

  tags = {
    Name = "Private_subnet"
  }
}
resource "aws_internet_gateway" "Internet_gateway" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "EIP" {
  vpc      = true
}

resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.Private_subnet.id

  tags = {
    Name = "NGW"
  }
}

resource "aws_route_table" "Route_table" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_gateway.id
  }
 tags = {
    Name = "Custom_Route_table"
  }
}
resource "aws_route_table" "Route_table2" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NGW.id
  }
 tags = {
    Name = "main"
  }
}

  resource "aws_route_table_association" "ass_1" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Route_table.id
}

  resource "aws_route_table_association" "ass_2" {
  subnet_id      = aws_subnet.Private_subnet.id
  route_table_id = aws_route_table.Route_table2.id
}
 
 
resource "aws_security_group" "sg" {
  name        = "First_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.VPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.VPC.cidr_block]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "First_SG"
  }
}