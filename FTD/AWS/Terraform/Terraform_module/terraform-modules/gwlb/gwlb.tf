#############################################################
# Resources 
#############################################################
resource "aws_lb" "gwlb" {
  name               = var.GWLB_name
  load_balancer_type = "gateway"
  subnets            = var.gwlb_subnet

  tags = {
    Name = var.GWLB_name
  }
}

resource "aws_lb_target_group" "gwlb-tg" {
  name     = "gwlb-tg"
  port     = 6081
  protocol = "GENEVE"
  target_type = "ip"
  vpc_id   = var.gwlb_vpc_id

  health_check {
    port     = 22
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.gwlb.id

  default_action {
    target_group_arn = aws_lb_target_group.gwlb-tg.id
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "instance_attach" {
  count = length(var.instance_ip)
  target_group_arn = aws_lb_target_group.gwlb-tg.id
  target_id        = var.instance_ip[count.index]
}
