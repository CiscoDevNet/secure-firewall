module "instance" {
  source                  = "../../module/FirewallServer/"
  FTD_version             = var.FTD_version
  FMC_version             = var.FMC_version
  keyname                 = var.keyname
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  fmc_mgmt_ip             = var.fmc_ip
  ftd_mgmt_interface      = module.network.mgmt_interface
  ftd_outside_interface   = module.network.outside_interface
  ftd_inside_interface    = module.network.inside_interface
  ftd_diag_interface      = module.network.diag_interface
  fmcmgmt_interface       = module.network.fmcmgmt_interface
}