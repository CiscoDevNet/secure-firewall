##########################################
# Gateway Load Balancing
##########################################

# Gateway Load Balancing related resources
resource "aws_lb" "gwlb" {
  name                             = "gwlb"
  load_balancer_type               = "gateway"
  subnets                          = [aws_subnet.inside_subnet.id]
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.env_name} Service GWLB"
    app  = "service"
  }
}

# Target group is IP based since FTD's are provisioned with multiple interfaces
resource "aws_lb_target_group" "ftd" {
  name        = "ftdtg"
  protocol    = "GENEVE"
  vpc_id      = aws_vpc.srvc_vpc.id
  target_type = "ip"
  port        = 6081
  stickiness {
    type = "source_ip_dest_ip"
  }
  health_check {
    port     = 22
    protocol = "TCP"
  }
  tags = {
    Name = "${var.env_name} Service GWLB TG"
    app  = "service"
  }
}


# GWLB Listener
resource "aws_lb_listener" "cluster" {
  load_balancer_arn = aws_lb.gwlb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ftd.arn
  }
  tags = {
    Name = "${var.env_name} Service GWLB Listener"
    app  = "service"
  }
}

# Endpoint Service
resource "aws_vpc_endpoint_service" "gwlb" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
  tags = {
    Name = "${var.env_name} Service GWLB EP Service"
    app  = "service"
  }
}

# GWLB Endpoints. One is required for each AZ in App VPC
resource "aws_vpc_endpoint" "fw" {
  service_name      = aws_vpc_endpoint_service.gwlb.service_name
  vpc_endpoint_type = aws_vpc_endpoint_service.gwlb.service_type
  vpc_id            = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } GWLBe"
  }
}

# Delay after GWLB Endpoint creation
resource "time_sleep" "fw" {
  create_duration = "180s"
  depends_on = [
    aws_vpc_endpoint.fw
  ]
}

# GWLB Endpoints are placed in FW Data subnets in Firewall VPC
resource "aws_vpc_endpoint_subnet_association" "fw" {
  vpc_endpoint_id = aws_vpc_endpoint.fw.id
  subnet_id       = aws_subnet.gwlbe_subnet.id
}