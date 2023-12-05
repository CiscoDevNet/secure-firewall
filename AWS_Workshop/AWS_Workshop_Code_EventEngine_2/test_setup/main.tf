resource "aws_security_group" "bastion_sg" {
  name = "Bation InterfaceSG"
  #vpc_id      = module.spoke_networks.vpc_id
  vpc_id      = ""
  description = "BASTION SG"
}

resource "aws_security_group_rule" "bastion_ingress" {
  count             = length(var.bastion_sg)
  type              = "ingress"
  from_port         = lookup(var.bastion_sg[count.index], "from_port", null)
  to_port           = lookup(var.bastion_sg[count.index], "to_port", null)
  protocol          = lookup(var.bastion_sg[count.index], "protocol", null)
  cidr_blocks       = lookup(var.bastion_sg[count.index], "cidr_blocks", null)
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "fmc_mgmt_sg_egress" {
  type              = "egress"
  description       = "Bastion SG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_network_interface" "bastion_interface" {
  description = "bastion"
  #subnet_id         = module.spoke_network.outside_subnet[1]
  subnet_id         = ""
  source_dest_check = false
  security_groups   = [aws_security_group.bastion_sg.id]
}

resource "aws_instance" "bastion_machine" {
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t3.micro"
  key_name      = var.keyname
  network_interface {
    network_interface_id = aws_network_interface.bastion_interface.id
    device_index         = 0
  }
  tags = {
    Name = "bastion"
  }
}

resource "aws_eip" "bastion_eip" {
  vpc = true
  tags = {
    "Name" = "Bastion Public IP"
  }
}

resource "aws_eip_association" "bastion_eip_assocation" {
  network_interface_id = aws_network_interface.bastion_interface.id
  allocation_id        = aws_eip.bastion_eip.id
}

#######################################

resource "aws_network_interface" "app_interface" {
  description = "application"
  #subnet_id         = module.spoke_network.outside_subnet[1]
  subnet_id         = ""
  source_dest_check = false
  security_groups   = [aws_security_group.bastion_sg.id]
}

resource "aws_instance" "app_machine" {
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t3.micro"
  key_name      = var.keyname
  network_interface {
    network_interface_id = aws_network_interface.app_interface.id
    device_index         = 0
  }
  tags = {
    Name = "application"
  }
}