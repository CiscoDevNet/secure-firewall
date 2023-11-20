module "load_balancer" {
  source                  = "../../module/LoadBalancer/"
  vpc_id                  = module.network.vpc_id
  ftd_outside_ip          = var.ftd_outside_ip
  outside_subnet_id       = module.network.outside_subnet #toset(module.network.outside_subnet)
  external_listener_ports = var.external_listener_ports
  create                  = var.create
  external_health_check   = var.external_health_check

}