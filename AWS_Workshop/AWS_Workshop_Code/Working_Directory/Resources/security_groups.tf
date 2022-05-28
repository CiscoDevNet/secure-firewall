module "security_groups" {
  source                = "../../module/SecurityGroups/"
  vpc_id                = module.network.vpc_id
  outside_interface_sg  = var.outside_interface_sg
  inside_interface_sg   = var.inside_interface_sg
  mgmt_interface_sg     = var.mgmt_interface_sg
  fmc_mgmt_interface_sg = var.fmc_mgmt_interface_sg
  mgmt_interface        = module.network.mgmt_interface
  outside_interface     = module.network.outside_interface
  inside_interface      = module.network.inside_interface
  diag_interface        = module.network.diag_interface
  fmcmgmt_interface     = module.network.fmcmgmt_interface
}