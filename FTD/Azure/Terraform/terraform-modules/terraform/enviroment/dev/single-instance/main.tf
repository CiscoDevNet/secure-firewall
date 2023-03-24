#--------------------------Resource Group--------------------------------#
module "rg" {
  source        = "../../../../terraform-modules/rg"
  rg_name       = var.rg_name
  location      = var.location
}

#--------------------------Network--------------------------------#
module "network" {
  source                  = "../../../../terraform-modules/network"
  rg_name                 = module.rg.resource_group_name[0]
  location                = module.rg.location[0]
  instances               = var.instances
  depends_on              = [module.rg]
 }

# # #--------------------------Firewall--------------------------------#
 module "server" {
  source                       = "../../../../terraform-modules/firewallserver"
  rg_name                      = module.rg.resource_group_name[0]
  location                     = module.rg.location[0]
  instances                    = var.instances
  ftdv-interface-management    = [module.network.mgmt_interface[0]]
  ftdv-interface-diagnostic    = [module.network.diag_interface[0]]
  ftdv-interface-outside       = [module.network.outside_interface[0]]
  ftdv-interface-inside        = [module.network.inside_interface[0]]
  depends_on                   = [module.rg, module.network]

}






