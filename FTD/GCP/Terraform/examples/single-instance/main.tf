module "ftd-1" {
  source                = "../../"
  num_instances         = 1
  project_id            = var.project_id
  region                = var.region
  vm_zones              = var.vm_zones
  networks              = var.networks
  vm_instance_labels    = var.vm_instance_labels
  vm_instance_tags      = var.vm_instance_tags
  vm_machine_type       = var.vm_machine_type
  cisco_product_version = var.cisco_product_version
  admin_ssh_pub_key     = var.admin_ssh_pub_key
  day_0_config          = var.day_0_config
  inside_network        = var.inside_network
  mgmt_network          = var.mgmt_network
  outside_network       = var.outside_network
  diag_network          = var.diag_network
  dmz_network           = var.dmz_network
  admin_password        = var.admin_password
  hostname              = var.hostname
}