# # #################################################################################################################################
# # # Security Group
# # #################################################################################################################################

resource "aws_security_group" "outside_sg" {
  name        = "Outside Interface SG"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.outside_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }
}

resource "aws_security_group" "inside_sg" {
  name        = "Inside Interface SG"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.inside_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }
}

resource "aws_security_group" "mgmt_sg" {
  name        = "FTD Management Interface SG"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.mgmt_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }
}

resource "aws_security_group" "fmc_mgmt_sg" {
  name        = "FMC Management Interface SG"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.fmc_mgmt_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }
}

resource "aws_network_interface_sg_attachment" "ftd_mgmt_attachment" {
  count                = length(var.mgmt_interface)
  depends_on           = [aws_security_group.mgmt_sg]
  security_group_id    = aws_security_group.mgmt_sg.id
  network_interface_id = var.mgmt_interface[count.index]
}

resource "aws_network_interface_sg_attachment" "ftd_outside_attachment" {
  count                = length(var.outside_interface)
  depends_on           = [aws_security_group.outside_sg]
  security_group_id    = aws_security_group.outside_sg.id
  network_interface_id = var.outside_interface[count.index]
}

resource "aws_network_interface_sg_attachment" "ftd_inside_attachment" {
  count                = length(var.inside_interface)
  depends_on           = [aws_security_group.inside_sg]
  security_group_id    = aws_security_group.inside_sg.id
  network_interface_id = var.inside_interface[count.index]
}

resource "aws_network_interface_sg_attachment" "ftd_diag_attachment" {
  count                = length(var.mgmt_interface)
  depends_on           = [aws_security_group.mgmt_sg]
  security_group_id    = aws_security_group.mgmt_sg.id
  network_interface_id = var.diag_interface[count.index]
}

resource "aws_network_interface_sg_attachment" "fmc_attachment" {
  depends_on           = [aws_security_group.fmc_mgmt_sg]
  security_group_id    = aws_security_group.fmc_mgmt_sg.id
  network_interface_id = fmcmgmt_interface[0]
}