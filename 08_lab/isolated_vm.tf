resource "aws_key_pair" "key_7875be2c-8" {
  key_name   = "7875be2c-key-8"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3Tr6WwHmv0ftlNXI4WaXaw2Tk+eIFe6fWVvG2qkT23 michael.fuchs@hm.edu"
  tags = {
    Name       = "key_7875be2c"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_internet_gateway" "igw_7875be2c_assignment_8" {
  vpc_id = aws_vpc.vpc_7875be2c_assignment_8.id
  tags = {
    Name       = "igw_7875be2c_assignment_8"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_main_route_table_association" "mrta_7875be2c_assignment_8" {
  vpc_id         = aws_vpc.vpc_7875be2c_assignment_8.id
  route_table_id = aws_route_table.route_igw_7875be2c_assignment_8.id
}

resource "aws_vpc" "vpc_7875be2c_assignment_8" {
  cidr_block = "10.0.0.0/23"
  tags = {
    Name       = "vpc_7875be2c_assignment_8"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_subnet" "subnet_7875be2c_assignment_8" {
  vpc_id            = aws_vpc.vpc_7875be2c_assignment_8.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name       = "subnet_a_7875be2c_assignment_8"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_route_table" "route_igw_7875be2c_assignment_8" {
  vpc_id = aws_vpc.vpc_7875be2c_assignment_8.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_7875be2c_assignment_8.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw_7875be2c_assignment_8.id
  }
  tags = {
    Name       = "vpc_7875be2c_assignment_8"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_network_acl" "network_acl_7875be2c_assignment_8" {
  vpc_id     = aws_vpc.vpc_7875be2c_assignment_8.id
  subnet_ids = [aws_subnet.subnet_7875be2c_assignment_8.id]
  tags = {
    Name       = "acl_7875be2c_assignment_8"
    user       = "7875be2c"
    assignment = "8"
  }
  ingress {
    action     = "allow"
    rule_no    = 100
    protocol   = "tcp"
    to_port    = 22
    from_port  = 22
    cidr_block = "0.0.0.0/0"
  }
  egress {
    action     = "allow"
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    action     = "allow"
    rule_no    = 110
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }
  egress {
    action     = "allow"
    rule_no    = 110
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_instance" "ec2_7875be2c_assignment_8" {
  ami                         = "ami-06c7e3ecba3661a89" # amazon linux 64bit on arm
  instance_type               = "t4g.nano"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key_7875be2c-8.key_name
  availability_zone           = "eu-central-1a"
  subnet_id                   = aws_subnet.subnet_7875be2c_assignment_8.id
  vpc_security_group_ids = [
    aws_security_group.sec_group_7875be2c_assignment_8.id
  ]
  depends_on = [
    aws_internet_gateway.igw_7875be2c_assignment_8
  ]
  tags = {
    Name       = "ec2_7875be2c_assignment_8"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_security_group" "sec_group_7875be2c_assignment_8" {
  name   = "sec_group_7875be2c_assignment_8"
  vpc_id = aws_vpc.vpc_7875be2c_assignment_8.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = [
      "217.80.121.19/32" # my ip address
    ]
    ipv6_cidr_blocks = [
      "2003:cb:f729:a000:c9d8:9727:579e:508b/128" # my ip address
    ]
  }
  egress {
    from_port = 443
    to_port   = 443
    protocol  = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    ipv6_cidr_blocks = [
      "::/0"
    ]
  }
  tags = {
    Name       = "sec_group_7875be2c_assignment_8"
    user       = "7875be2c"
    assignment = "8"
  }
}
