locals {
  app_subnet = var.app_subnet_cidr != [] ? aws_subnet.app_subnet : data.aws_subnet.appftd
}

data "template_file" "apache_install" {
  template = file("${path.module}/apache_install.tpl")
}

data "aws_subnet" "appftd" {
  count = var.app_subnet_cidr == [] ? length(var.app_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.app_subnet_name[count.index]]
  }
}

resource "aws_subnet" "app_subnet" {
  count             = var.app_subnet_cidr != null ? length(var.app_subnet_cidr) : 0
  vpc_id            = module.network.vpc_id
  cidr_block        = var.app_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.app_subnet_name[count.index]
  }, var.tags)
}

resource "aws_network_interface" "ftd_app" {
  #count = length(var.dmz_subnet_cidr) != 0 ? length(var.dmz_subnet_cidr) : 0  ||  length(var.dmz_subnet_name) != 0 ? length(var.dmz_subnet_name) : 0
  count             = length(var.app_interface) != 0 ? length(var.app_interface) : length(var.ftd_app_ip)
  description       = "asa{count.index}-app"
  subnet_id         = local.app_subnet[count.index].id
  source_dest_check = false
  private_ips       = [var.ftd_app_ip[count.index]]
}

resource "aws_security_group" "app_sg" {
  name        = "Allow All App"
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

  tags = merge({
    Name = "Public Allow"
  }, var.tags)
}

resource "aws_network_interface_sg_attachment" "ftd_app_attachment" {
  count                = length(var.app_interface) != 0 ? length(var.app_interface) : length(var.ftd_app_ip)
  depends_on           = [aws_network_interface.ftd_app]
  security_group_id    = aws_security_group.app_sg.id
  network_interface_id = aws_network_interface.ftd_app[count.index].id
}

resource "aws_route_table" "ftd_app_route" {
  vpc_id = module.network.vpc_id
  tags = merge({
    Name = "app network Routing table"
  }, var.tags)
}

resource "aws_route_table_association" "app_association" {
  count          = var.app_subnet_cidr != null ? length(var.app_subnet_cidr) : length(var.app_subnet_name)
  subnet_id      = var.app_subnet_cidr != null ? aws_subnet.app_subnet[count.index].id : data.aws_subnet.appftd[count.index].id
  route_table_id = aws_route_table.ftd_app_route.id
}

resource "aws_instance" "EC2-Ubuntu" {
  depends_on = [
    aws_instance.testLinux
  ]
  count         = 2
  ami           = "ami-0851b76e8b1bce90b" 
  instance_type = "t2.micro"
  key_name      = "appKeys"
  
  user_data = data.template_file.apache_install.rendered
  network_interface {
    network_interface_id = aws_network_interface.ftd_app[count.index].id
    device_index         = 0
  }

  tags = {
    Name = "Ec2-Ubuntu${count.index+1}"
  }
}
resource "aws_key_pair" "deployer2" {
  key_name   = "appKeys"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnLBaURFhnwuIdMmT6vHw6WtBXgiiFw3UM6MGWkN1nBXLYzyr0d1qplOq1G1wwUMdmk7Mcx3OGZTKTexzNAmtnJIBg6qTrjfAjL9u+MZsLk1iVBp+anK9g5iph/W6fyv+ulO+OWXo4Oa0UF/rO7Naongv+kEpD84M+qU93DKFLI02Ngh/biFmAi6I+DWTF7nwGUHX2yRkcTo9HLr2qpcAq1C4RamlEGQ+yiDYOG+s/xBSTgrk7/t5DZ56at/f+k7AtwsAa2AVbGOjPSyUvuXdSg2NeU2G2gS6oWq+m7/YTCnP4F8hZ+ssFoDfzzT8B7XD2TGe4APz9uc7b0zXhv+X1 kadadhic@KADADHIC-M-L059"
}
resource "aws_lb" "app-lb" {
  name                             = "App-LB"
  load_balancer_type               = "network"
  internal                         = true
  enable_cross_zone_load_balancing = "true"
  subnet_mapping {
    subnet_id            = local.app_subnet[0].id
    private_ipv4_address = "10.0.5.100"
  }

  subnet_mapping {
    subnet_id            = local.app_subnet[1].id
    private_ipv4_address = "10.0.50.100"
  }
}

resource "aws_lb_listener" "app_listener" {
  for_each = { for k, v in var.internal_listener_ports : k => v }
  load_balancer_arn = aws_lb.app-lb.arn
  port              = each.value.port
  protocol          = each.value.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_front_end[each.key].arn
 }
}

resource "aws_lb_target_group" "app_front_end" {
  #for_each    = var.create == "both"  || var.create == "internal" ? var.internal_listener_ports : []
  for_each = { for k, v in var.internal_listener_ports : k => v }
  name        = tostring("fe2-1-${each.key}")
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type
  vpc_id      = module.network.vpc_id

  health_check {
    interval = 30
    protocol = var.internal_health_check.protocol
    port     = var.internal_health_check.port
  }
}

resource "aws_lb_target_group_attachment" "app_target" {
  count            = length(var.ftd_app_ip)
  depends_on       = [aws_lb_target_group.app_front_end]
  target_group_arn = aws_lb_target_group.app_front_end[0].arn
  target_id        = var.ftd_app_ip[count.index]
}

output "app_interface" {
  value = aws_network_interface.ftd_app.*.id
}

output "app_subnet" {
  value = var.app_subnet_cidr != null ? aws_subnet.app_subnet.*.id : data.aws_subnet.appftd.*.id
}

output "app_interface_ip" {
  value = aws_network_interface.ftd_app.*.private_ip_list
}