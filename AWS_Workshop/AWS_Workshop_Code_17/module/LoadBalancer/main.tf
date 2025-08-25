# # #########################################################################################################
# # # Creation of Load Balancer
# # #########################################################################################################

resource "aws_lb" "external-lb" {
  count = var.create == "both"  || var.create == "external" ? 1 : 0
  name                             = "External-LB"
  internal                         = false
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"
  subnets                          = var.outside_subnet_id
}

resource "aws_lb" "internal-lb" {
  count = var.create == "both"  || var.create == "internal" ? 1 : 0
  name                             = "Internal-LB"
  internal                         = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"
  subnets                          = var.inside_subnet_id
}

resource "aws_lb_listener" "external_listener" {
  #for_each = var.create == "both"  || var.create == "external" ? var.external_listener_ports : []
  for_each = { for k, v in var.external_listener_ports : k => v if var.create == "both"  || var.create == "external" }
  load_balancer_arn = aws_lb.external-lb[0].arn
  port              = each.value.port
  protocol          = each.value.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_front_end[each.key].arn
  }
}

# # #####################################################################
# # //optional  -- Only required when you want to use Internal LB.
# # ###################################################################### 
resource "aws_lb_listener" "internal_listener" {
  #for_each = var.create == "both"  || var.create == "external" ? var.internal_listener_ports : []
  for_each = { for k, v in var.internal_listener_ports : k => v if var.create == "both"  || var.create == "internal" }
  load_balancer_arn = aws_lb.internal-lb[0].arn
  port              = each.value.port
  protocol          = each.value.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_front_end[each.key].arn
 }
}

resource "aws_lb_target_group" "external_front_end" {
  #for_each    = var.create == "both"  || var.create == "external" ? var.external_listener_ports : []
  for_each = { for k, v in var.external_listener_ports : k => v if var.create == "both"  || var.create == "external" }
  name        = tostring("fe1-1-${each.key}")
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type
  vpc_id      = var.vpc_id

  health_check {
    interval = 30
    protocol = var.external_health_check.protocol
    port     = var.external_health_check.port
  }
}


# # #####################################################################
# # //optional  -- Only required when you want to use Internal LB.
# # ###################################################################### 
resource "aws_lb_target_group" "internal_front_end" {
  #for_each    = var.create == "both"  || var.create == "internal" ? var.internal_listener_ports : []
  for_each = { for k, v in var.internal_listener_ports : k => v if var.create == "both"  || var.create == "internal" }
  name        = tostring("fe2-1-${each.key}")
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type
  vpc_id      = var.vpc_id

  health_check {
    interval = 30
    protocol = var.internal_health_check.protocol
    port     = var.internal_health_check.port
  }
}


resource "aws_lb_target_group_attachment" "target1" {
  count            = length(var.ftd_outside_ip)
  depends_on       = [aws_lb_target_group.external_front_end]
  target_group_arn = aws_lb_target_group.external_front_end[0].arn
  target_id        = var.ftd_outside_ip[count.index]
}

# # #####################################################################
# # //optional  -- Only required to map the target group to Internal LB.
# # ###################################################################### 
resource "aws_lb_target_group_attachment" "target2" {
  count            = length(var.ftd_inside_ip)
  depends_on       = [aws_lb_target_group.internal_front_end]
  target_group_arn = aws_lb_target_group.internal_front_end[0].arn
  target_id        = var.ftd_inside_ip[count.index]
}


