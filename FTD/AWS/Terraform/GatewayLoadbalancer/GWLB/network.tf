#######################################################
#Locals
#######################################################
locals {
  vpc = var.use_existing_vpc ? data.aws_vpc.secure[0] : aws_vpc.secure[0]
}
#######################################################
#New VPC
#######################################################
resource "aws_vpc" "secure" {
  count = var.use_existing_vpc ? 0 : 1
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  count = var.use_existing_vpc ? 0 : 1
  vpc_id = aws_vpc.secure[0].id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

resource "aws_subnet" "outside" {
  count = var.use_existing_vpc ? 0 : length(var.aws_availability_zones)
  vpc_id = aws_vpc.secure[0].id
  cidr_block = cidrsubnet(join("/",[split("/", aws_vpc.secure[0].cidr_block)[0], "23"]), 5, length(var.aws_availability_zones)+count.index)
  availability_zone = var.aws_availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Outside"
  }
}

resource "aws_subnet" "management" {
  count = var.use_existing_vpc ? 0 : length(var.aws_availability_zones)
  vpc_id = aws_vpc.secure[0].id
  cidr_block = cidrsubnet(join("/",[split("/", aws_vpc.secure[0].cidr_block)[0], "23"]), 5, 2*length(var.aws_availability_zones)+count.index)
  availability_zone = var.aws_availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Management"
  }
}

resource "aws_subnet" "inside" {
  count = var.use_existing_vpc ? 0 : length(var.aws_availability_zones)
  vpc_id = aws_vpc.secure[0].id
  cidr_block = cidrsubnet(join("/",[split("/", aws_vpc.secure[0].cidr_block)[0], "23"]), 5, 3*length(var.aws_availability_zones)+count.index)
  availability_zone = var.aws_availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Inside"
  }
}
#######################################################
#Existing VPC
#######################################################
data "aws_vpc" "secure" {
  count = var.use_existing_vpc ? 1 : 0
  tags = {
    Name = var.vpc_name
  }
}

data "aws_internet_gateway" "igw" {
  count = var.use_existing_vpc ? 1 : 0
  tags = {
    Name = var.igw_name
  }
}

data "aws_subnet" "outside" {
  count = var.use_existing_vpc ? length(var.aws_availability_zones) : 0
  vpc_id = local.vpc.id
  tags = {
    Name = var.appliance_subnet[count.index]
  }
}
###################################################
resource "aws_subnet" "glwbe" {
  count = length(var.aws_availability_zones)
  vpc_id = local.vpc.id
  cidr_block = cidrsubnet(join("/",[split("/", local.vpc.cidr_block)[0], "19"]), 5, (24 + count.index))
  availability_zone = var.aws_availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "GLWBE-${count.index + 1}"
  }
}

resource "aws_subnet" "ngw" {
  count = length(var.aws_availability_zones)
  vpc_id = local.vpc.id
  cidr_block = cidrsubnet(join("/",[split("/", local.vpc.cidr_block)[0], "19"]), 5, (28 + count.index))
  availability_zone = var.aws_availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "NATGW-${count.index + 1}"
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.aws_availability_zones)
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  count = length(var.aws_availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.ngw[count.index].id

  tags = {
    Name = "NAT-GW-${count.index + 1}"
  }
}

resource "aws_route_table" "gwlbe_rt" {
  depends_on = [
    aws_nat_gateway.natgw
  ]
  count = length(var.aws_availability_zones)
  vpc_id = local.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw[count.index].id
  }

  tags = {
    Name = "GWLB-RT-${count.index + 1}"
  }
}

resource "aws_route_table_association" "gwlbe_rta" {
  count = length(var.aws_availability_zones)
  subnet_id      = aws_subnet.glwbe[count.index].id
  route_table_id = aws_route_table.gwlbe_rt[count.index].id
}

resource "aws_route_table" "ngw_rt" {
  count = length(var.aws_availability_zones)
  vpc_id = local.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.use_existing_vpc ? data.aws_internet_gateway.igw[0].id : aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = "NGW-RT-${count.index + 1}"
  }
}

resource "aws_route_table_association" "ngw_rta" {
  count = length(var.aws_availability_zones)
  subnet_id      = aws_subnet.ngw[count.index].id
  route_table_id = aws_route_table.ngw_rt[count.index].id
}

output "nat_route_table" {
    value = aws_route_table.ngw_rt.*.id
}

output "gwlbe_route_table" {
    value = aws_route_table.gwlbe_rt.*.id
}