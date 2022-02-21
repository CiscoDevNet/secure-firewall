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
  asa_mgmt_interface      = module.network.mgmt_interface[0]
  asa_outside_interface   = module.network.outside_interface[0]
  asa_inside_interface    = module.network.inside_interface[0]
  asa_dmz_interface       = module.network.dmz_interface[0]
}
