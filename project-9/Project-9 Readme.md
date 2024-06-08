# AWS Infrastructure Setup Using Terraform

### Introduction

This guide demonstrates how to use Terraform to provision a basic AWS infrastructure, including a Virtual Private Cloud (VPC), subnets, security groups, an internet gateway, a NAT gateway, route tables, and an EC2 instance. Each step is explained in detail to help you understand the configuration.

### Prerequisites

Before you begin, make sure you have the following:

- AWS CLI installed and configured with access and secret keys.
- Terraform installed on your local machine.

### Step 1: Configure AWS CLI

1. Install the AWS CLI on your machine.
2. Configure it using your AWS access and secret keys.

### Step 2: Configure AWS Provider in Terraform

```hcl
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
```

Replace `<YOUR_ACCESS_KEY>` and `<YOUR_SECRET_KEY>` with your actual AWS access and secret keys.

### Step 3: Creation of VPC

```hcl
# main.tf
resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test_VPC"
  }
}
```

This creates a VPC with the specified CIDR block and tags it with a name.

### Step 4: Creation of Public and Private Subnets

```hcl
# main.tf
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
```

These resources create public and private subnets within the VPC.

### Step 5: Creation of Security Group

```hcl
# main.tf
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
```

This resource creates a security group allowing SSH traffic.

### Step 6: Creation of Internet Gateway

```hcl
# main.tf
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test_igw"
  }
}
```

This resource creates an internet gateway and attaches it to the VPC.

### Step 7: Creation of Elastic IP and NAT Gateway

```hcl
# main.tf
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
```

These resources create an Elastic IP and a NAT gateway.

### Step 8: Creation of Public and Private Route Tables

```hcl
# main.tf
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
```

These resources create route tables for public and private subnets.

### Step 9: Create Public & Private Route Table Association

```hcl
# main.tf
resource "aws_route_table_association" "test_public_routetable_assoc" {
  subnet_id      = aws_subnet.test_VPC_public_subnet.id
  route_table_id = aws_route_table.test_vpc_public_route_table.id
}

resource "aws_route_table_association" "test_private_routetable_assoc" {
  subnet_id      = aws_subnet.test_VPC_private_subnet.id
  route_table_id = aws_route_table.test_vpc_private_route_table.id
}
```

These resources associate the route tables with the corresponding subnets.

### Step 10: Creation of an EC2 instance using this VPC

```hcl
# main.tf
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
```

This resource creates an EC2 instance in the public subnet.

### Step 11: Instance Configuration

After creating the instance, SSH into it through Session Manager:

1. Navigate to `/etc/ssh`.
2. Edit the `sshd_config` file to enable password authentication.
3. Set a password for the desired username using `sudo passwd username`.

Now you can SSH into the instance using the

 password.

### Conclusion

This guide demonstrates how to provision a basic AWS infrastructure using Terraform. You can customize and extend this setup according to your requirements.

---

