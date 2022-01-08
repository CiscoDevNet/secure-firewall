###############
# Locals
###############
locals {

  # convert flatten networks back to a list of objects
  net = [
    {
      name        = var.network_1_name
      vcn_cidr    = var.network_1_vcn_cidr
      subnet_cidr = var.network_1_subnet_cidr
      private_ip  = var.network_1_private_ip
      external_ip = var.network_1_external_ip
    },
    {
      name        = var.network_2_name
      vcn_cidr    = var.network_2_vcn_cidr
      subnet_cidr = var.network_2_subnet_cidr
      private_ip  = var.network_2_private_ip
      external_ip = var.network_2_external_ip
    },
    {
      name        = var.network_3_name
      vcn_cidr    = var.network_3_vcn_cidr
      subnet_cidr = var.network_3_subnet_cidr
      private_ip  = var.network_3_private_ip
      external_ip = var.network_3_external_ip
    },
    {
      name        = var.network_4_name
      vcn_cidr    = var.network_4_vcn_cidr
      subnet_cidr = var.network_4_subnet_cidr
      private_ip  = var.network_4_private_ip
      external_ip = var.network_4_external_ip
    }
  ]

  networks = var.network_5_name != "" ? concat(local.net, [{
      name        = var.network_5_name
      vcn_cidr    = var.network_5_vcn_cidr
      subnet_cidr = var.network_5_subnet_cidr
      private_ip  = var.network_5_private_ip
      external_ip = var.network_5_external_ip
    }]) : local.net
}


###############
# VCN networks
###############
module "networking" {
  source          = "./modules/networking"
  compartment_id  = var.compartment_id
  region          = var.region
  label_prefix    = var.label_prefix
  networks        = local.networks
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
  network_5_name         = var.network_5_name
  tenancy_ocid           = var.tenancy_ocid
  compartment_id         = var.compartment_id
  region                 = var.region
  multiple_ad            = var.multiple_ad
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