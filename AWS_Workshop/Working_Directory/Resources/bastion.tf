data "template_file" "bastion_install" {
  template = file("${path.module}/bastion_install.tpl")
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "bastion_subnet" {
  vpc_id            = module.network.vpc_id
  cidr_block        = var.bastion_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge({
    Name = var.bastion_subnet_name
  }, var.tags)
}

resource "aws_network_interface" "bastion_interface" {
  description       = "bastion-interface"
  subnet_id         = aws_subnet.bastion_subnet.id
  private_ips       = [var.bastion_ip]
}

resource "aws_network_interface_sg_attachment" "bastion_attachment" {
  depends_on           = [aws_network_interface.bastion_interface]
  security_group_id    = aws_security_group.bastion_sg.id
  network_interface_id = aws_network_interface.bastion_interface.id
}

resource "aws_route_table" "bastion_route" {
  vpc_id = module.network.vpc_id
  tags = merge({
    Name = "bastion network Routing table"
  }, var.tags)
}

resource "aws_route_table_association" "bastion_association" {
  subnet_id      = aws_subnet.bastion_subnet.id
  route_table_id = aws_route_table.bastion_route.id
}

resource "aws_route" "bastion_default_route" {
  route_table_id         = aws_route_table.bastion_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.network.internet_gateway[0]
}

resource "aws_instance" "testLinux" {
  ami           = "ami-0851b76e8b1bce90b" 
  instance_type = "t2.micro"
  key_name      = "sshKeys"
  user_data = data.template_file.bastion_install.rendered
  network_interface {
    network_interface_id = aws_network_interface.bastion_interface.id
    device_index         = 0
  }

  tags = {
    Name = "bastion"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "sshKeys"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVzdPiYvbzdLl1+fRnqE4sKXJ3mxoDY1hT43gyoizVTMkyfdkY9l5tt/DZvVNSuIsmGT6fb2xRotCR9Q08UJIF3K1SE2A8xT6HaE0sXzHoSKRu1ZK6nKxm2aRsM0SX5oRnY1zXfQE00EfLZN4p/NcBQF/wrbZHmqlWobopsBhMZTbEzqALFxjWRy8nEZGBrP0NbOmedZD1Hy4OuwxjgiKErNL9el7KEDLe5c3dTAvSIwa5JJGBDpv66zqO1AGF9Bk4ECNpNzarmL8FORyjbFRRCqnAXsB7OESnNwQWZWeZqtBhqbChPuzMOU7LMnDaOHdQ7iG6DfNrvBb1iuYvQZJZ kadadhic@KADADHIC-M-L059"
}

resource "aws_security_group" "bastion_sg" {
  name        = "Allow All Bastion"
  description = "Allow all traffic"
  vpc_id      = module.network.vpc_id


  dynamic "ingress" {
    for_each = var.security_group_ingress_with_cidr
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }


  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = lookup(egress.value, "from_port", null)
      to_port     = lookup(egress.value, "to_port", null)
      protocol    = lookup(egress.value, "protocol", null)
      cidr_blocks = lookup(egress.value, "cidr_blocks", null)
      description = lookup(egress.value, "description", null)
    }
  }
}

