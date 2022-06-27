module "network" {
  source              = "../../../../terraform-modules/network"
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  create_igw          = var.create_igw
  mgmt_subnet_cidr    = var.mgmt_subnet_cidr
  ftd_mgmt_ip         = var.ftd_mgmt_ip
  outside_subnet_cidr = var.outside_subnet_cidr
  ftd_outside_ip      = var.ftd_outside_ip
  diag_subnet_cidr    = var.diag_subnet_cidr
  ftd_diag_ip         = var.ftd_diag_ip
  inside_subnet_cidr  = var.inside_subnet_cidr
  ftd_inside_ip       = var.ftd_inside_ip
  fmc_ip              = var.fmc_ip
  mgmt_subnet_name    = var.mgmt_subnet_name
  outside_subnet_name = var.outside_subnet_name
  diag_subnet_name    = var.diag_subnet_name
  inside_subnet_name  = var.inside_subnet_name
}

module "instance" {
  source                  = "../../../../terraform-modules/firewallserver"
  keyname                 = var.keyname
  create_fmc              = var.create_fmc
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  fmc_mgmt_ip             = var.fmc_ip
  ftd_mgmt_interface      = module.network.mgmt_interface
  ftd_inside_interface    = module.network.inside_interface
  ftd_outside_interface   = module.network.outside_interface
  ftd_diag_interface      = module.network.diag_interface
  fmcmgmt_interface       = module.network.fmcmgmt_interface
}

