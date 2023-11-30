################################################
# Routing
################################################

# Mgmt Route Table
resource "aws_route_table" "mgmt_route_table" {
  vpc_id = aws_vpc.srvc_vpc.id
  tags = {
    Name = "${var.env_name} Service Mgmt Route Table"
  }
}

# Mgmt Default Route Routes
resource "aws_route" "mgmt_default_route" {
  depends_on = [aws_internet_gateway.mgmt_igw]
  route_table_id         = aws_route_table.mgmt_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mgmt_igw.id
}

# Mgmt Route Associations
resource "aws_route_table_association" "mgmt_association" {
  subnet_id      = aws_subnet.mgmt_subnet.id
  route_table_id = aws_route_table.mgmt_route_table.id
}

# Lambda Route Table
resource "aws_route_table" "lambda_route_table" {
  vpc_id = aws_vpc.srvc_vpc.id
  tags = {
    Name = "${var.env_name} Lambda Mgmt Route Table"
  }
}

# Lambda Default Route Routes
resource "aws_route" "lambda_default_route" {
  depends_on = [aws_nat_gateway.lambda_nat]
  route_table_id         = aws_route_table.lambda_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.lambda_nat.id
}

# Lambda Route Associations
resource "aws_route_table_association" "lambda_association" {
  subnet_id      = aws_subnet.lambda_subnet.id
  route_table_id = aws_route_table.lambda_route_table.id
}

# App Route Table
resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } App Route Table"
  }
}

# App Default route to GWLB Endpoint
resource "aws_route" "app_default_route" {
  depends_on = [aws_vpc_endpoint.fw, aws_vpc_endpoint_subnet_association.fw]
  route_table_id         = aws_route_table.app_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.fw.id
}

# App Subnet Route Association to App Route Table
resource "aws_route_table_association" "app1_association" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_route_table.id
}

##############################################################
# GWLBe Subnet Routing
##############################################################

# GWLBe Route Table
resource "aws_route_table" "gwlbe_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } GWLBe Route Table"
  }
}
#
# GWLBe Default route to Internet Gateway
resource "aws_route" "gwlbe_default_route" {
  depends_on = [aws_internet_gateway.app_igw]
  route_table_id         = aws_route_table.gwlbe_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}
#
## GWLBe Subnet Route Associations to GWLBe Route Table
resource "aws_route_table_association" "gwlbe_association" {
  subnet_id      = aws_subnet.gwlbe_subnet.id
  route_table_id = aws_route_table.gwlbe_route_table.id
}

##############################################################
# App IGW Routing
##############################################################

# App IGW Route Table
resource "aws_route_table" "app_igw_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } IGW Route Table"
  }
}

# App IGW route to App Subnet via GWLBe
resource "aws_route" "app1_igw_route_app1_subnet" {
  depends_on = [aws_vpc_endpoint.fw, aws_vpc_endpoint_subnet_association.fw]
  route_table_id         = aws_route_table.app_igw_route_table.id
  destination_cidr_block = var.app_subnet
  vpc_endpoint_id        = aws_vpc_endpoint.fw.id
}

## App IGW Associations to App1 IGW Route Table
resource "aws_route_table_association" "app_igw_association" {
  gateway_id     = aws_internet_gateway.app_igw.id
  route_table_id = aws_route_table.app_igw_route_table.id
}

# Internet Gateways

# Service Mgmt IGW
resource "aws_internet_gateway" "mgmt_igw" {
  vpc_id = aws_vpc.srvc_vpc.id
  tags = {
    Name = "${var.env_name} Service Mgmt-IGW"
  }
}

# App IGW
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } IGW"
  }
}

# Lambda Nat-GW

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "lambda_nat" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.mgmt_subnet.id
  depends_on = [aws_internet_gateway.mgmt_igw]
}
