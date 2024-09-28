
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_subnet" "bastion_subnet" {
  vpc_id                  = aws_vpc.ftd_vpc.id
  cidr_block              = "10.1.5.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${var.prefix}-bastion-Subnet"
  }, var.tags)
}

resource "aws_network_interface" "bastion_interface" {
  description = "bastion-interface"
  subnet_id   = aws_subnet.bastion_subnet.id
  private_ips = ["10.1.5.22"]
}

resource "aws_network_interface_sg_attachment" "bastion_attachment" {
  depends_on           = [aws_network_interface.bastion_interface]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.bastion_interface.id
}

resource "aws_route_table" "bastion_route" {
  vpc_id = aws_vpc.ftd_vpc.id
  tags = merge({
    Name = "${var.prefix}-bastion network Routing table"
  }, var.tags)
}

resource "aws_route_table_association" "bastion_association" {
  subnet_id      = aws_subnet.bastion_subnet.id
  route_table_id = aws_route_table.bastion_route.id
}

resource "aws_route" "bastion_default_route" {
  route_table_id         = aws_route_table.bastion_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.int_gw.id
}

resource "aws_instance" "testLinux" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "${var.prefix}-Cisco-Key"
  network_interface {
    network_interface_id = aws_network_interface.bastion_interface.id
    device_index         = 0
  }

  tags = {
    Name = "${var.prefix}-bastion"
  }
}

################################################################################################
# App server 
################################################################################################
resource "aws_network_interface" "app_interface" {
  description = "app-interface"
  subnet_id   = aws_subnet.inside_subnet.id
  private_ips = ["10.1.3.22"]
}

resource "aws_network_interface_sg_attachment" "app_attachment" {
  depends_on           = [aws_network_interface.app_interface]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.app_interface.id
}

resource "aws_instance" "appLinux" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "${var.prefix}-Cisco-Key"
  network_interface {
    network_interface_id = aws_network_interface.app_interface.id
    device_index         = 0
  }

  tags = {
    Name = "${var.prefix}-app"
  }
}


