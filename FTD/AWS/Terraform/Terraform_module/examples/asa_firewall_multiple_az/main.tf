module "network" {
  source                   = "../../../../terraform-modules/network"
  vpc_cidr                 = var.vpc_cidr
  vpc_name                 = var.vpc_name
  create_igw               = var.create_igw
  availability_zone_count  = var.availability_zone_count
  instances_per_az         = var.instances_per_az
  mgmt_subnet_cidr         = var.mgmt_subnet_cidr
  inside_subnet_cidr       = var.inside_subnet_cidr
  outside_subnet_cidr      = var.outside_subnet_cidr
  diag_subnet_cidr         = var.diag_subnet_cidr
  ftd_mgmt_ip              = var.ftd_mgmt_ip
  ftd_outside_ip           = var.ftd_outside_ip
  ftd_diag_ip              = var.ftd_diag_ip
  ftd_inside_ip            = var.ftd_inside_ip
  fmc_ip                   = var.fmc_ip
  inside_subnet_name       = var.inside_subnet_name
  outside_subnet_name      = var.outside_subnet_name
  diag_subnet_name         = var.diag_subnet_name
  mgmt_subnet_name         = var.mgmt_subnet_name
}

module "instance" {
  source                   = "../../../../terraform-modules/firewallserver"
  FTD_version              = var.FTD_version
  FMC_version              = var.FMC_version
  instances_per_az         = var.instances_per_az
  availability_zone_count  = var.availability_zone_count
  keyname                  = var.keyname
  fmc_mgmt_ip              = var.fmc_ip
  ftd_mgmt_interface       = module.network.mgmt_interface
  ftd_inside_interface     = module.network.inside_interface
  ftd_outside_interface    = module.network.outside_interface
  ftd_diag_interface       = module.network.diag_interface
  fmcmgmt_interface        = module.network.fmcmgmt_interface
}

