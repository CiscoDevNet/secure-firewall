# =====================================================
# Transit Gateway
# =====================================================

resource "aws_ec2_transit_gateway" "main_tgw" {
  description                     = "Main Transit Gateway for ${var.prefix}"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name        = "${var.prefix}-Transit-Gateway"
    Environment = var.environment
    Project     = var.project
  }
}

# Transit Gateway VPC Attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "security_vpc_attachment" {
  subnet_ids         = [aws_subnet.tgw.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.security_vpc.id

  tags = {
    Name        = "${var.prefix}-Security-VPC-TGW-Attachment"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke1_vpc_attachment" {
  subnet_ids         = [aws_subnet.spoke1_private.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.spoke1_vpc.id

  tags = {
    Name        = "${var.prefix}-Spoke-1-VPC-TGW-Attachment"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke2_vpc_attachment" {
  subnet_ids         = [aws_subnet.spoke2_private.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.spoke2_vpc.id

  tags = {
    Name        = "${var.prefix}-Spoke-2-VPC-TGW-Attachment"
    Environment = var.environment
    Project     = var.project
  }
}

# =====================================================
# Transit Gateway Route Tables for Centralized Security
# =====================================================

# Security VPC Route Table (EastWest Firewall)
resource "aws_ec2_transit_gateway_route_table" "security_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id

  tags = {
    Name        = "${var.prefix}-Security-TGW-RT"
    Environment = var.environment
    Project     = var.project
  }
}

# Spoke1 VPC Route Table
resource "aws_ec2_transit_gateway_route_table" "spoke1_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id

  tags = {
    Name        = "${var.prefix}-Spoke1-TGW-RT"
    Environment = var.environment
    Project     = var.project
  }
}

# Spoke2 VPC Route Table
resource "aws_ec2_transit_gateway_route_table" "spoke2_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id

  tags = {
    Name        = "${var.prefix}-Spoke2-TGW-RT"
    Environment = var.environment
    Project     = var.project
  }
}

# =====================================================
# Transit Gateway Route Table Associations
# =====================================================

# Associate Security VPC with Security Route Table
resource "aws_ec2_transit_gateway_route_table_association" "security_vpc_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security_rt.id
}

# Associate Spoke1 VPC with Spoke1 Route Table
resource "aws_ec2_transit_gateway_route_table_association" "spoke1_vpc_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke1_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke1_rt.id
}

# Associate Spoke2 VPC with Spoke2 Route Table
resource "aws_ec2_transit_gateway_route_table_association" "spoke2_vpc_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke2_rt.id
}

# =====================================================
# Transit Gateway Routes for Centralized EastWest Inspection
# =====================================================

# Security VPC Route Table Routes (EastWest Firewall can reach both spokes directly)
resource "aws_ec2_transit_gateway_route" "security_to_spoke1" {
  destination_cidr_block         = var.spoke1_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke1_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security_rt.id
}

resource "aws_ec2_transit_gateway_route" "security_to_spoke2" {
  destination_cidr_block         = var.spoke2_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security_rt.id
}

# Spoke1 Route Table Routes (All Spoke1 traffic goes through Security VPC)
resource "aws_ec2_transit_gateway_route" "spoke1_to_security" {
  destination_cidr_block         = var.security_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke1_rt.id
}

# Spoke1 to Spoke2 traffic routes through Security VPC (EastWest Firewall)
resource "aws_ec2_transit_gateway_route" "spoke1_to_spoke2_via_security" {
  destination_cidr_block         = var.spoke2_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke1_rt.id
}

# Default route from Spoke1 to Security VPC (for internet access)
resource "aws_ec2_transit_gateway_route" "spoke1_default_to_security" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke1_rt.id
}

# Spoke2 Route Table Routes (All Spoke2 traffic goes through Security VPC)
resource "aws_ec2_transit_gateway_route" "spoke2_to_security" {
  destination_cidr_block         = var.security_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke2_rt.id
}

# Spoke2 to Spoke1 traffic routes through Security VPC (EastWest Firewall)
resource "aws_ec2_transit_gateway_route" "spoke2_to_spoke1_via_security" {
  destination_cidr_block         = var.spoke1_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke2_rt.id
}

# Default route from Spoke2 to Security VPC (for internet access)
resource "aws_ec2_transit_gateway_route" "spoke2_default_to_security" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke2_rt.id
}