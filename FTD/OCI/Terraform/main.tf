###############
# VCN networks
###############
module "networking" {
  source          = "./modules/networking"
  compartment_id  = var.compartment_id
  region          = var.region
  label_prefix    = var.label_prefix
  networks        = var.networks
  inside_network  = var.inside_network
  mgmt_network    = var.mgmt_network
  outside_network = var.outside_network
  dmz_network     = var.dmz_network
  diag_network    = var.diag_network
}


###############
# Appliance VM(s)
###############

module "vm" {
  source = "./modules/vm"

  num_instances          = var.num_instances
  networks_list          = module.networking.networks_list
  vm_ads_number          = var.vm_ads_number
  tenancy_ocid           = var.tenancy_ocid
  compartment_id         = var.compartment_id
  region                 = var.region
  mp_listing_resource_id = var.mp_listing_resource_id
  vm_compute_shape       = var.vm_compute_shape
  admin_ssh_pub_key      = var.admin_ssh_pub_key
  admin_password         = var.admin_password
  day_0_config           = var.day_0_config
  hostname               = var.hostname

  depends_on = [
    module.networking
  ]
}