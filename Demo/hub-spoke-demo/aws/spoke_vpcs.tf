# =====================================================
# Spoke VPCs and Subnets
# =====================================================

# Spoke-1 VPC
resource "aws_vpc" "spoke1_vpc" {
  cidr_block           = var.spoke1_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.prefix}-Spoke-1-VPC"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_subnet" "spoke1_private" {
  vpc_id            = aws_vpc.spoke1_vpc.id
  cidr_block        = var.spoke1_private_subnet_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "${var.prefix}-Spoke-1-Private-Subnet"
    Environment = var.environment
    Project     = var.project
  }
}

# Spoke-2 VPC
resource "aws_vpc" "spoke2_vpc" {
  cidr_block           = var.spoke2_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.prefix}-Spoke-2-VPC"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_subnet" "spoke2_private" {
  vpc_id            = aws_vpc.spoke2_vpc.id
  cidr_block        = var.spoke2_private_subnet_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name        = "${var.prefix}-Spoke-2-Private-Subnet"
    Environment = var.environment
    Project     = var.project
  }
}

# =====================================================
# Spoke VPC Route Tables
# =====================================================

# Spoke-1 VPC Route Table
resource "aws_route_table" "spoke1_private_rt" {
  vpc_id = aws_vpc.spoke1_vpc.id

  tags = {
    Name        = "${var.prefix}-Spoke1-Private-RT"
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [aws_ec2_transit_gateway.main_tgw]
}

# Routes for Spoke1 Private Route Table
resource "aws_route" "spoke1_to_spoke2" {
  route_table_id         = aws_route_table.spoke1_private_rt.id
  destination_cidr_block = var.spoke2_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_route" "spoke1_to_security" {
  route_table_id         = aws_route_table.spoke1_private_rt.id
  destination_cidr_block = var.security_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_route" "spoke1_default" {
  route_table_id         = aws_route_table.spoke1_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_route_table_association" "spoke1_private" {
  subnet_id      = aws_subnet.spoke1_private.id
  route_table_id = aws_route_table.spoke1_private_rt.id
}

# Spoke-2 VPC Route Table
resource "aws_route_table" "spoke2_private_rt" {
  vpc_id = aws_vpc.spoke2_vpc.id

  tags = {
    Name        = "${var.prefix}-Spoke2-Private-RT"
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [aws_ec2_transit_gateway.main_tgw]
}

# Routes for Spoke2 Private Route Table
resource "aws_route" "spoke2_to_spoke1" {
  route_table_id         = aws_route_table.spoke2_private_rt.id
  destination_cidr_block = var.spoke1_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_route" "spoke2_to_security" {
  route_table_id         = aws_route_table.spoke2_private_rt.id
  destination_cidr_block = var.security_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_route" "spoke2_default" {
  route_table_id         = aws_route_table.spoke2_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_route_table_association" "spoke2_private" {
  subnet_id      = aws_subnet.spoke2_private.id
  route_table_id = aws_route_table.spoke2_private_rt.id
}

# =====================================================
# Ubuntu Instances in Spoke VPCs
# =====================================================

# Ubuntu instance in Spoke-1 VPC
resource "aws_instance" "ubuntu_spoke1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ubuntu_instance_type
  key_name              = aws_key_pair.deployer.key_name
  subnet_id             = aws_subnet.spoke1_private.id
  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]

  user_data_base64 = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y htop iperf3 traceroute
    hostnamectl set-hostname ubuntu-spoke1
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config  
    echo "ubuntu:Cisco@123" | sudo chpasswd
    sudo systemctl restart sshd
    EOF
  )

  tags = {
    Name        = "${var.prefix}-Ubuntu-Spoke1"
    Environment = var.environment
    Project     = var.project
  }
}

# Ubuntu instance in Spoke-2 VPC
resource "aws_instance" "ubuntu_spoke2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ubuntu_instance_type
  key_name              = aws_key_pair.deployer.key_name
  subnet_id             = aws_subnet.spoke2_private.id
  vpc_security_group_ids = [aws_security_group.ubuntu_spoke2_sg.id]

  user_data_base64 = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y htop iperf3 traceroute
    hostnamectl set-hostname ubuntu-spoke2

    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config  
    echo "ubuntu:Cisco@123" | sudo chpasswd
    sudo systemctl restart sshd
    EOF
  )

  tags = {
    Name        = "${var.prefix}-Ubuntu-Spoke2"
    Environment = var.environment
    Project     = var.project
  }
}