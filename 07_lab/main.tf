terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_key_pair" "key_7875be2c" {
  key_name   = "7875be2c-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3Tr6WwHmv0ftlNXI4WaXaw2Tk+eIFe6fWVvG2qkT23 michael.fuchs@hm.edu"
  tags = {
    Name       = "key_7875be2c"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_internet_gateway" "igw_7875be2c_assignment_7" {
  vpc_id = aws_vpc.vpc_7875be2c_assignment_7.id
  tags = {
    Name       = "igw_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_main_route_table_association" "mrta_7875be2c_assignment_7" {
  vpc_id         = aws_vpc.vpc_7875be2c_assignment_7.id
  route_table_id = aws_route_table.route_igw_7875be2c_assignment_7.id
}

resource "aws_vpc" "vpc_7875be2c_assignment_7" {
  cidr_block = "10.0.0.0/23"
  tags = {
    Name       = "vpc_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_subnet" "subnet_a_7875be2c_assignment_7" {
  vpc_id            = aws_vpc.vpc_7875be2c_assignment_7.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name       = "subnet_a_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_subnet" "subnet_b_7875be2c_assignment_7" {
  vpc_id            = aws_vpc.vpc_7875be2c_assignment_7.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1b"
  tags = {
    Name       = "subnet_b_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_route_table" "route_igw_7875be2c_assignment_7" {
  vpc_id = aws_vpc.vpc_7875be2c_assignment_7.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_7875be2c_assignment_7.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw_7875be2c_assignment_7.id
  }
  tags = {
    Name       = "vpc_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_network_acl" "network_acl_a_7875be2c_assignment_7" {
  vpc_id     = aws_vpc.vpc_7875be2c_assignment_7.id
  subnet_ids = [aws_subnet.subnet_a_7875be2c_assignment_7.id]
  tags = {
    Name       = "acl_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
  ingress {
    action     = "allow"
    rule_no    = 110
    protocol   = "tcp"
    to_port    = 22
    from_port  = 22
    cidr_block = "0.0.0.0/0"
  }
  egress {
    action     = "allow"
    rule_no    = 110
    protocol   = "tcp"
    to_port    = 22
    from_port  = 22
    cidr_block = "0.0.0.0/0"
  }
  egress {
    action     = "allow"
    rule_no    = 100
    protocol   = "udp"
    to_port    = 8080
    from_port  = 8080
    cidr_block = aws_subnet.subnet_b_7875be2c_assignment_7.cidr_block
  }


  egress {
    action     = "allow"
    rule_no    = 90
    protocol   = "tcp"
    to_port    = 0
    from_port  = 0
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_network_acl" "network_acl_b_7875be2c_assignment_7" {
  vpc_id     = aws_vpc.vpc_7875be2c_assignment_7.id
  subnet_ids = [aws_subnet.subnet_b_7875be2c_assignment_7.id]
  tags = {
    Name       = "acl_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
  ingress {
    action     = "allow"
    rule_no    = 100
    protocol   = "udp"
    to_port    = 8080
    from_port  = 8080
    cidr_block = aws_subnet.subnet_a_7875be2c_assignment_7.cidr_block
  }
  ingress {
    action     = "allow"
    rule_no    = 110
    protocol   = "tcp"
    to_port    = 22
    from_port  = 22
    cidr_block = "0.0.0.0/0"
  }
  egress {
    action     = "allow"
    rule_no    = 110
    protocol   = "tcp"
    to_port    = 22
    from_port  = 22
    cidr_block = "0.0.0.0/0"
  }


  egress {
    action     = "allow"
    rule_no    = 90
    protocol   = "tcp"
    to_port    = 0
    from_port  = 0
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_instance" "ec2_a_7875be2c_assignment_7" {
  ami                         = "ami-06c7e3ecba3661a89" # amazon linux 64bit on arm
  instance_type               = "t4g.nano"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key_7875be2c.key_name
  availability_zone           = "eu-central-1a"
  subnet_id                   = aws_subnet.subnet_a_7875be2c_assignment_7.id
  vpc_security_group_ids = [
    aws_security_group.sec_group_a_7875be2c_assignment_7.id
  ]
  depends_on = [
    aws_internet_gateway.igw_7875be2c_assignment_7
  ]
  tags = {
    Name       = "ec2_a_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_instance" "ec2_b_7875be2c_assignment_7" {
  ami                         = "ami-06c7e3ecba3661a89" # amazon linux 64bit on arm
  instance_type               = "t4g.nano"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key_7875be2c.key_name
  availability_zone           = "eu-central-1b"
  subnet_id                   = aws_subnet.subnet_b_7875be2c_assignment_7.id
  vpc_security_group_ids = [
    aws_security_group.sec_group_b_7875be2c_assignment_7.id
  ]
  depends_on = [
    aws_internet_gateway.igw_7875be2c_assignment_7
  ]
  tags = {
    Name       = "ec2_b_7875be2c_assignment_7"
    user       = "7875be2c"
    assignment = "7"
  }
}

resource "aws_security_group" "sec_group_a_7875be2c_assignment_7" {
  name   = "sec_group_a_7875be2c_assignment_7"
  vpc_id = aws_vpc.vpc_7875be2c_assignment_7.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = [
      "217.80.121.19/32" # my ip address
    ]
    ipv6_cidr_blocks = [
      "2003:cb:f729:a000:b940:34a5:8d42:ff3f/128" # my ip address
    ]
  }
  egress {
    from_port = 80
    to_port   = 80
    protocol  = "TCP"
    cidr_blocks = [
      aws_subnet.subnet_b_7875be2c_assignment_7.cidr_block
    ]
  }
  egress {
    from_port = 8080
    to_port   = 8080
    protocol  = "UDP"
    cidr_blocks = [
      aws_subnet.subnet_b_7875be2c_assignment_7.cidr_block
    ]
  }
}

resource "aws_security_group" "sec_group_b_7875be2c_assignment_7" {
  name   = "sec_group_b_7875be2c_assignment_7"
  vpc_id = aws_vpc.vpc_7875be2c_assignment_7.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = [
      "217.80.121.19/32" # my ip address
    ]
    ipv6_cidr_blocks = [
      "2003:cb:f729:a000:b940:34a5:8d42:ff3f/128" # my ip address
    ]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "TCP"
    cidr_blocks = [
      aws_subnet.subnet_a_7875be2c_assignment_7.cidr_block
    ]
  }
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "UDP"
    cidr_blocks = [
      aws_subnet.subnet_a_7875be2c_assignment_7.cidr_block
    ]
  }
}
