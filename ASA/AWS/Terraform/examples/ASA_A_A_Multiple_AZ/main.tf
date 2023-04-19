module "network" {
  source              = "../../module/Network/"
  vpc_cidr            = var.vpc_cidr
  inside_subnet_cidr  = var.inside_subnet_cidr
  outside_subnet_cidr = var.outside_subnet_cidr
  dmz_subnet_cidr     = var.dmz_subnet_cidr
  mgmt_subnet_cidr    = var.mgmt_subnet_cidr
  asa_mgmt_ip         = var.asa_mgmt_ip
  asa_outside_ip      = var.asa_outside_ip
  asa_dmz_ip          = var.asa_dmz_ip
  asa_inside_ip       = var.asa_inside_ip
  inside_subnet_name  = var.inside_subnet_name
  outside_subnet_name  = var.outside_subnet_name
  dmz_subnet_name  = var.dmz_subnet_name
  mgmt_subnet_name  = var.mgmt_subnet_name
}


module "instance" {
  source                  = "../../module/FirewallServer/"
  keyname                 = var.keyname
  asa_size                = var.asa_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  asa_mgmt_interface      = [module.network.mgmt_interface[0],module.network.mgmt_interface[1]]
  asa_outside_interface   = [module.network.outside_interface[0],module.network.outside_interface[1]]
  asa_inside_interface    = [module.network.inside_interface[0],module.network.inside_interface[1]]
  asa_dmz_interface       = [module.network.dmz_interface[0],module.network.dmz_interface[1]]
}

module "load_balancer" {
  source              = "../../module/LoadBalancer/"
  vpc_id              = module.network.vpc_id
  asa01_inside_ip     = element(element(module.network.inside_interface_ip,0),0)
  asa02_inside_ip     = element(element(module.network.inside_interface_ip,1),1)
  asa01_outside_ip    = element(element(module.network.outside_interface_ip,0),0)
  asa02_outside_ip    = element(element(module.network.outside_interface_ip,1),1)
  outside01_subnet_id = module.network.outside_subnet[0]
  outside02_subnet_id = module.network.outside_subnet[1]
  inside01_subnet_id  = module.network.inside_subnet[0]
  inside02_subnet_id  = module.network.inside_subnet[1]
}