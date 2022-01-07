###############
# Locals
###############
locals {
  ha_enabled = var.num_instances > 1 ? true : false
}

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
  dmz1_network    = var.dmz1_network
  dmz2_network    = var.dmz2_network
}


###############
# Appliance VM(s)
###############

module "vm" {
  source = "./modules/vm"

  num_instances          = var.num_instances
  networks_list          = module.networking.networks_list
  tenancy_ocid           = var.tenancy_ocid
  compartment_id         = var.compartment_id
  region                 = var.region
  vm_ads_number          = var.vm_ads_number
  mp_listing_resource_id = var.mp_listing_resource_id
  vm_compute_shape       = var.vm_compute_shape
  startup_script         = var.startup_script
  admin_ssh_pub_key      = var.admin_ssh_pub_key
  enable_password        = var.enable_password
  day_0_config           = var.day_0_config

  depends_on = [
    module.networking
  ]
}


##############################
# External and Internal LB
##############################

module "lb-1" {
  count  = local.ha_enabled ? 1 : 0
  source = "./modules/load_balancer"

  networks_map   = module.networking.networks_map
  instance_ids   = module.vm.instance_ids
  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  region         = var.region
  vm_ads_number  = var.vm_ads_number
  num_instances  = var.num_instances
  service_port   = var.service_port
  inside_network = var.inside_network
  outside_network   = var.outside_network


  depends_on = [
    module.vm
  ]
}