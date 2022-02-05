#############################################################
# Resources 
#############################################################
resource "aws_lb" "gwlb" {
  name               = var.GWLB_name
  load_balancer_type = "gateway"
  subnets            = var.use_existing_vpc ? [for subnet in data.aws_subnet.outside : subnet.id] : [for subnet in aws_subnet.outside : subnet.id]

  tags = {
    Name = var.GWLB_name
  }
}

resource "aws_lb_target_group" "gwlb-tg" {
  name     = "gwlb-tg"
  port     = 6081
  protocol = "GENEVE"
  target_type = "ip"
  vpc_id   = local.vpc.id

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

resource "aws_vpc_endpoint_service" "glwbes" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
}

resource "aws_vpc_endpoint" "glwbe" {
  count             = length(aws_subnet.glwbe.*.id)
  service_name      = aws_vpc_endpoint_service.glwbes.service_name
  subnet_ids        = [element(aws_subnet.glwbe.*.id, count.index)]
  vpc_endpoint_type = aws_vpc_endpoint_service.glwbes.service_type
  vpc_id            = local.vpc.id
  tags = {
    Name = "GWLBE-${var.aws_availability_zones[count.index]}"
  }
}

resource "aws_lb_target_group_attachment" "instance_attach" {
  count = length(var.instance)
  target_group_arn = aws_lb_target_group.gwlb-tg.id
  target_id        = var.instance[count.index]
}

output "vpc_id" {
    value = local.vpc.id
}

output "az-id_endpoint_map" {
    value = zipmap(var.aws_availability_zones, aws_vpc_endpoint.glwbe.*.id)
}