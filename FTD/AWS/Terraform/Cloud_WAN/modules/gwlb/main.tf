# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.
#############################################################
# Resources 
#############################################################
resource "aws_lb" "gwlb" {
  name                             = "${var.prefix}-${var.gwlb_name}"
  load_balancer_type               = "gateway"
  subnets                          = var.gwlb_subnet
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.prefix}-${var.gwlb_name}"
  }
}

resource "aws_lb_target_group" "gwlb_tg" {
  name        = "${var.prefix}-${var.gwlb_tg_name}"
  port        = 6081
  protocol    = "GENEVE"
  target_type = "ip"
  vpc_id      = var.gwlb_vpc_id

  health_check {
    port     = 443
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.gwlb.id

  default_action {
    target_group_arn = aws_lb_target_group.gwlb_tg.id
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "instance_attach" {
  count            = length(var.instance_ip)
  target_group_arn = aws_lb_target_group.gwlb_tg.id
  target_id        = var.instance_ip[count.index]
}
