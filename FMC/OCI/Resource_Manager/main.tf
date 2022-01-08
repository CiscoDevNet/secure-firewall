locals {
  use_existing_network = var.network_strategy == var.network_strategy_enum["USE_EXISTING_VCN_SUBNET"] ? true : false

  subnet_id = local.use_existing_network ? var.subnet_id : module.networking[0].subnet_id
}

###############
# VCN networks
###############
module "networking" {
  count                       = local.use_existing_network ? 0 : 1
  source                      = "./modules/networking"
  compartment_id              = var.compartment_id
  region                      = var.region
  label_prefix                = var.label_prefix
  mangement_vcn_display_name  = var.mangement_vcn_display_name
  mangement_vcn_cidr_block    = var.mangement_vcn_cidr_block
  mangement_subnet_cidr_block = var.mangement_subnet_cidr_block
  appliance_ips               = var.appliance_ips
}


###############
# Appliance VM(s)
###############

module "vm" {
  source = "./modules/vm"

  num_instances          = var.num_instances
  subnet_id              = local.subnet_id
  appliance_ips          = var.appliance_ips
  multiple_ad            = var.multiple_ad
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