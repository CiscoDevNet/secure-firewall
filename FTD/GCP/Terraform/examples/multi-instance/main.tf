locals {
  network_project_id   = var.network_project_id != "" ? var.network_project_id : var.project_id
  subnet_self_link_fmc     = module.networking.subnet_self_link_fmc
}

#############################################
# Enable required services on the project
#############################################
resource "google_project_service" "service" {
  for_each = toset(var.project_services)
  project  = var.project_id

  service = each.key

  # Do not disable the service on destroy. This may be a shared project, and
  # we might not "own" the services we enable.
  disable_on_destroy = false
}

#############################################
# Service Account for cisco appliance vm
#############################################
module "service_accounts" {
  source          = "../.././modules/service_accounts"
  sa_account_id   = "cisco-created-sa"
  sa_display_name = "Cisco Service Account"
  sa_description  = "Terraform-managed service account"
}

module "networking" {
  source           = "../.././modules/networking"
  project_id       = var.project_id
  region           = var.region
  networks         = var.networks
  inside_network   = var.inside_network
  mgmt_network     = var.mgmt_network
  outside_network  = var.outside_network
  dmz_network      = var.dmz_network
  diag_network     = var.diag_network
  custom_route_tag = var.custom_route_tag
  service_account  = module.service_accounts.email
  appliance_ips_fmc    = var.appliance_ips_fmc
}

module "vm" {
  source = "../.././modules/vm"

  networks_list         = module.networking.networks_list
  mgmt_network          = var.mgmt_network
  project_id            = var.project_id
  region                = var.region
  num_instances         = var.num_instances
  ftd_hostname          = var.ftd_hostname
  fmc_hostname          = var.fmc_hostname
  vm_zones              = var.vm_zones
  custom_route_tag      = var.custom_route_tag
  vm_machine_type       = var.vm_machine_type
  vm_instance_labels    = var.vm_instance_labels
  vm_instance_tags      = var.vm_instance_tags
  cisco_product_version = var.cisco_product_version
  service_account       = module.service_accounts.email
  admin_ssh_pub_key     = var.admin_ssh_pub_key
  day_0_config_ftd      = var.day_0_config_ftd
  day_0_config_fmc      = var.day_0_config_fmc
  admin_password        = var.admin_password
  appliance_ips_fmc     = var.appliance_ips_fmc
  subnet_self_link_fmc  = local.subnet_self_link_fmc
  network_project_id    = local.network_project_id
  boot_disk_type        = var.boot_disk_type
  boot_disk_size        = var.boot_disk_size
  depends_on = [
    module.networking
  ]
}