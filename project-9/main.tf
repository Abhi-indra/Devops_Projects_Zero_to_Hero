# terraform.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "<YOUR_ACCESS_KEY>"
  secret_key = "<YOUR_SECRET_KEY>"
}

# main.tf
resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test_VPC"
  }
}

resource "aws_subnet" "test_VPC_public_subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "test_public_subnet"
  }
}

resource "aws_subnet" "test_VPC_private_subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "test_private_subnet"
  }
}

resource "aws_security_group" "test-sg" {
  name        = "test-sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress = [
    {
      description      = "Allow SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.test-vpc.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "Allow SSH"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test_igw"
  }
}

resource "aws_eip" "test_elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "test_nat_gateway" {
  allocation_id = aws_eip.test_elastic_ip.id
  subnet_id     = aws_subnet.test_VPC_public_subnet.id

  tags = {
    Name = "test Internet gateway"
  }
  depends_on = [aws_internet_gateway.test_igw]
}

resource "aws_route_table" "test_vpc_public_route_table" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "VPC_Public_RouteTable"
  }
}

resource "aws_route_table" "test_vpc_private_route_table" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.test_nat_gateway.id
  }

  tags = {
    Name = "VPC_Private_RouteTable"
  }
}

resource "aws_route_table_association" "test_public_routetable_assoc" {
  subnet_id      = aws_subnet.test_VPC_public_subnet.id
  route_table_id = aws_route_table.test_vpc_public_route_table.id
}

resource "aws_route_table_association" "test_private_routetable_assoc" {
  subnet_id      = aws_subnet.test_VPC_private_subnet.id
  route_table_id = aws_route_table.test_vpc_private_route_table.id
}

resource "aws_instance" "Test_Instance" {
  ami                            = "ami-0f5ee92e2d63afc18"
  instance_type                  = "t2.micro"
  key_name                       = "testkey"
  subnet_id                      = aws_subnet.test_VPC_public_subnet.id
  vpc_security_group_ids         = [aws_security_group.test-sg.id]
  associate_public_ip_address    = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = true
  }

  tags = {
    Name = "Testing Instance"
  }
}
