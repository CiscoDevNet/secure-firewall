# # #########################################################################################################
# # # Creation of Load Balancer
# # #########################################################################################################

resource "aws_lb" "external01-lb" {

  name                             = "External01-LB"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"

  subnet_mapping {
    subnet_id = var.outside01_subnet_id

  }
  subnet_mapping {
    subnet_id = var.outside02_subnet_id

  }
}

resource "aws_lb" "external02-lb" {

  name                             = "External02-LB"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"


  subnet_mapping {
    subnet_id = var.outside01_subnet_id


  }
  subnet_mapping {
    subnet_id = var.outside02_subnet_id

  }
}

resource "aws_lb" "internal01-lb" {
  name                             = "Inside01-LB"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"


  subnet_mapping {
    subnet_id = var.inside01_subnet_id
  }
  subnet_mapping {
    subnet_id = var.inside02_subnet_id
  }
}


resource "aws_lb" "internal02-lb" {
  name                             = "Inside02-LB"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"



  subnet_mapping {
    subnet_id = var.inside01_subnet_id
  }
  subnet_mapping {
    subnet_id = var.inside01_subnet_id
  }
}


resource "aws_lb_listener" "listener1-1" {
  load_balancer_arn = aws_lb.external01-lb.arn
  for_each          = var.listener_ports
  port              = each.key
  protocol          = each.value
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end1-1[each.key].arn
  }
}

resource "aws_lb_listener" "listener1-2" {
  load_balancer_arn = aws_lb.external02-lb.arn
  for_each          = var.listener_ports
  port              = each.key
  protocol          = each.value
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end1-2[each.key].arn
  }
}

# # #####################################################################
# # //optional  -- Only required when you want to use Internal LB.
# # ###################################################################### 
# # #resource "aws_lb_listener" "listener2-1" {
# # #  load_balancer_arn = aws_lb.internal01-lb.arn
# # #  for_each          = var.listener_ports
# # #  port              = each.key
# # #  protocol          = each.value
# # #  default_action {
# # #    type             = "forward"
# # #    target_group_arn = aws_lb_target_group.front_end2-1[each.key].arn
# # #  }
# # #}

# # #resource "aws_lb_listener" "listener2-2" {
# # #  load_balancer_arn = aws_lb.internal02-lb.arn
# # #  for_each          = var.listener_ports
# # #  port              = each.key
# # #  protocol          = each.value
# # #  default_action {
# # #    type             = "forward"
# # #    target_group_arn = aws_lb_target_group.front_end2-2[each.key].arn
# # #  }
# # #}


resource "aws_lb_target_group" "front_end1-1" {
  for_each    = var.listener_ports
  name        = tostring("fe1-1-${each.key}")
  port        = each.key
  protocol    = each.value
  target_type = "ip"
  vpc_id      = var.vpc_id


  health_check {
    interval = 30
    protocol = var.health_check.protocol
    port     = var.health_check.port
  }

}

resource "aws_lb_target_group" "front_end1-2" {
  for_each    = var.listener_ports
  name        = tostring("fe1-2-${each.key}")
  port        = each.key
  protocol    = each.value
  target_type = "ip"
  vpc_id      = var.vpc_id


  health_check {
    interval = 30
    protocol = var.health_check.protocol
    port     = var.health_check.port
  }
}

# # #####################################################################
# # //optional  -- Only required when you want to use Internal LB.
# # ###################################################################### 
# # #resource "aws_lb_target_group" "front_end2-1" {
# # #  for_each    = var.listener_ports
# # #  name        = tostring("fe2-1-${each.key}")
# # #  port        = each.key
# # #  protocol    = each.value
# # #  target_type = "ip"
# # #  vpc_id      = var.vpc_id

# # #  health_check {
# # #    interval = 30
# # #    protocol = var.health_check.protocol
# # #    port     = var.health_check.port
# # #  }
# # #}

# # #resource "aws_lb_target_group" "front_end2-2" {
# # #  for_each    = var.listener_ports
# # #  name        = tostring("fe2-2-${each.key}")
# # #  port        = each.key
# # #  protocol    = each.value
# # #  target_type = "ip"
# # #  vpc_id      = var.vpc_id

# # #  health_check {
# # #    interval = 30
# # #    protocol = var.health_check.protocol
# # #    port     = var.health_check.port
# # #  }
# # #}

resource "aws_lb_target_group_attachment" "target1_1a" {
  for_each         = var.listener_ports
  depends_on       = [aws_lb_target_group.front_end1-1]
  target_group_arn = aws_lb_target_group.front_end1-1[each.key].arn
  target_id        = var.asa01_outside_ip
}

resource "aws_lb_target_group_attachment" "target1_1b" {
  for_each         = var.listener_ports
  depends_on       = [aws_lb_target_group.front_end1-2]
  target_group_arn = aws_lb_target_group.front_end1-2[each.key].arn
  target_id        = var.asa01_outside_ip
}

resource "aws_lb_target_group_attachment" "target1_2a" {
  for_each         = var.listener_ports
  depends_on       = [aws_lb_target_group.front_end1-1]
  target_group_arn = aws_lb_target_group.front_end1-1[each.key].arn
  target_id        = var.asa02_outside_ip
}

resource "aws_lb_target_group_attachment" "target1_2b" {
  for_each         = var.listener_ports
  depends_on       = [aws_lb_target_group.front_end1-2]
  target_group_arn = aws_lb_target_group.front_end1-2[each.key].arn
  target_id        = var.asa02_outside_ip
}
# # #####################################################################
# # //optional  -- Only required to map the target group to Internal LB.
# # ###################################################################### 
# # #resource "aws_lb_target_group_attachment" "target2_1a" {
# # #  for_each         = var.listener_ports
# # #  depends_on       = [aws_lb_target_group.front_end2-1]
# # #  target_group_arn = aws_lb_target_group.front_end2-1[each.key].arn
# # #  target_id        = var.asa01_inside_ip
# # #}

# # #resource "aws_lb_target_group_attachment" "target2_1b" {
# # #  for_each         = var.listener_ports
# # #  depends_on       = [aws_lb_target_group.front_end2-2]
# # #  target_group_arn = aws_lb_target_group.front_end2-2[each.key].arn
# # #  target_id        = var.asa01_inside_ip
# # #}

# # //optional
# # #resource "aws_lb_target_group_attachment" "target2_2a" {
# # #  for_each         =   var.listener_ports
# # #    depends_on       = [aws_lb_target_group.front_end2-1]
# # #    target_group_arn = aws_lb_target_group.front_end2-1[each.key].arn
# # #    target_id        = var.asa02_inside_ip
# # #}

# # #resource "aws_lb_target_group_attachment" "target2_2b" {
# # #  for_each         =   var.listener_ports
# # #    depends_on       = [aws_lb_target_group.front_end2-2]
# # #    target_group_arn = aws_lb_target_group.front_end2-2[each.key].arn
# # #    target_id        = var.asa02_inside_ip
# # #}
  