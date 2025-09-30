# =====================================================
# Security VPC and Subnets
# =====================================================

resource "aws_vpc" "security_vpc" {
  cidr_block           = var.security_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.prefix}-Security-VPC"
    Environment = var.environment
    Project     = var.project
  }
}

# Internet Gateway for Security VPC
resource "aws_internet_gateway" "security_igw" {
  vpc_id = aws_vpc.security_vpc.id

  tags = {
    Name        = "${var.prefix}-Security-IGW"
    Environment = var.environment
    Project     = var.project
  }
}

# Shared Subnets for all 3 FTDv instances
resource "aws_subnet" "management" {
  vpc_id                  = aws_vpc.security_vpc.id
  cidr_block              = var.management_subnet_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.prefix}-Management-Subnet"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_subnet" "diagnostic" {
  vpc_id            = aws_vpc.security_vpc.id
  cidr_block        = var.diagnostic_subnet_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "${var.prefix}-Diagnostic-Subnet"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_subnet" "outside" {
  vpc_id                  = aws_vpc.security_vpc.id
  cidr_block              = var.outside_subnet_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.prefix}-Outside-Subnet"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_subnet" "inside" {
  vpc_id            = aws_vpc.security_vpc.id
  cidr_block        = var.inside_subnet_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "${var.prefix}-Inside-Subnet"
    Environment = var.environment
    Project     = var.project
  }

}

resource "aws_subnet" "tgw" {
  vpc_id            = aws_vpc.security_vpc.id
  cidr_block        = var.tgw_subnet_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "${var.prefix}-TGW-Subnet"
    Environment = var.environment
    Project     = var.project
  }
}

# =====================================================
# Security VPC Route Tables
# =====================================================

# Management Route Table - For Management subnet
resource "aws_route_table" "management_rt" {
  vpc_id = aws_vpc.security_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.security_igw.id
  }

  tags = {
    Name        = "${var.prefix}-Management-RT"
    Environment = var.environment
    Project     = var.project
  }
}

# Outside Route Table - For Outside subnet
resource "aws_route_table" "outside_rt" {
  vpc_id = aws_vpc.security_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.security_igw.id
  }

  tags = {
    Name        = "${var.prefix}-Outside-RT"
    Environment = var.environment
    Project     = var.project
  }
}

# Private Route Table for Inside subnets
resource "aws_route_table" "security_private_rt" {
  vpc_id = aws_vpc.security_vpc.id

  tags = {
    Name        = "${var.prefix}-Security-Private-RT"
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [aws_ec2_transit_gateway.main_tgw]
}

# Routes for Security Private Route Table - Return traffic back to TGW
resource "aws_route" "security_private_to_spoke1" {
  route_table_id         = aws_route_table.security_private_rt.id
  destination_cidr_block = var.spoke1_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_route" "security_private_to_spoke2" {
  route_table_id         = aws_route_table.security_private_rt.id
  destination_cidr_block = var.spoke2_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

# Associate management subnet with management route table
resource "aws_route_table_association" "management_association" {
  subnet_id      = aws_subnet.management.id
  route_table_id = aws_route_table.management_rt.id
}

# Associate outside subnet with outside route table
resource "aws_route_table_association" "outside_association" {
  subnet_id      = aws_subnet.outside.id
  route_table_id = aws_route_table.outside_rt.id
}

# Transit Gateway Route Table - For TGW subnet
resource "aws_route_table" "tgw_rt" {
  vpc_id = aws_vpc.security_vpc.id

  tags = {
    Name        = "${var.prefix}-TGW-RT"
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [aws_ec2_transit_gateway.main_tgw]
}

# Routes for Transit Gateway Route Table
# Internet traffic to Egress FTDv inside interface
resource "aws_route" "tgw_to_egress" {
  route_table_id         = aws_route_table.tgw_rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.egress_inside.id
}

# Inter-spoke traffic to EastWest FTDv inside interface
resource "aws_route" "tgw_spoke1_to_eastwest" {
  route_table_id         = aws_route_table.tgw_rt.id
  destination_cidr_block = var.spoke1_vpc_cidr
  network_interface_id   = aws_network_interface.eastwest_inside.id
}

resource "aws_route" "tgw_spoke2_to_eastwest" {
  route_table_id         = aws_route_table.tgw_rt.id
  destination_cidr_block = var.spoke2_vpc_cidr
  network_interface_id   = aws_network_interface.eastwest_inside.id
}

# Associate inside subnet with private route table
resource "aws_route_table_association" "inside_private" {
  subnet_id      = aws_subnet.inside.id
  route_table_id = aws_route_table.security_private_rt.id
}

# Associate TGW subnet with TGW route table
resource "aws_route_table_association" "tgw_association" {
  subnet_id      = aws_subnet.tgw.id
  route_table_id = aws_route_table.tgw_rt.id
}