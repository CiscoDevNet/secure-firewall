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
  ami           = "ami-0287a05f0ef0e9d9a" 
  instance_type = "t3.micro"
  key_name      = var.keyname 
  user_data = data.template_file.bastion_install.rendered
  network_interface {
    network_interface_id = aws_network_interface.bastion_interface.id
    device_index         = 0
  }

  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "Bastion SG"
  vpc_id      = module.network.vpc_id


  dynamic "ingress" {
    for_each = var.bastion_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

