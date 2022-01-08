###############
# Locals
###############
locals {
  network_project_id   = var.network_project_id != "" ? var.network_project_id : var.project_id
  use_existing_network = var.subnet != null && var.subnet != "" ? true : false
  subnet_self_link     = local.use_existing_network ? data.google_compute_subnetwork.mgmt_subnetwork[0].self_link : module.networking[0].subnet_self_link
  subnet_name          = local.use_existing_network ? data.google_compute_subnetwork.mgmt_subnetwork[0].name : module.networking[0].subnet_name
}

data "google_compute_subnetwork" "mgmt_subnetwork" {
  provider = google
  count    = local.use_existing_network ? 1 : 0
  name     = var.subnet
  region   = var.region
  project  = local.network_project_id
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
  source          = "./modules/service_accounts"
  sa_account_id   = "cisco-fmc-sa"
  sa_display_name = "Cisco FMC Service Account"
  sa_description  = "Terraform-managed service account"
}

###############
# VCP networks
###############
module "networking" {
  count                     = local.use_existing_network ? 0 : 1
  source                    = "./modules/networking"
  project_id                = var.project_id
  region                    = var.region
  network                   = var.network
  network_subnet_cidr_range = var.network_subnet_cidr_range
  #service_account           = module.service_accounts.email
  custom_route_tag = var.custom_route_tag
  appliance_ips    = var.appliance_ips
}

module "firewall" {
  source          = "./modules/firewall"
  project_id      = var.project_id
  network         = var.network
  service_account = module.service_accounts.email

  depends_on = [
    module.networking
  ]
}
###############
# Appliance VM(s)
###############

module "vm" {
  source                = "./modules/vm"
  subnet_self_link      = local.subnet_self_link
  network_project_id    = local.network_project_id
  appliance_ips         = var.appliance_ips
  project_id            = var.project_id
  region                = var.region
  hostname              = var.hostname
  num_instances         = var.num_instances
  vm_machine_type       = var.vm_machine_type
  vm_instance_labels    = var.vm_instance_labels
  vm_instance_tags      = var.vm_instance_tags
  cisco_product_version = var.cisco_product_version
  service_account       = module.service_accounts.email
  admin_ssh_pub_key     = var.admin_ssh_pub_key
  day_0_config          = var.day_0_config
  admin_password        = var.admin_password
  boot_disk_type        = var.boot_disk_type
  boot_disk_size        = var.boot_disk_size
  depends_on = [
    module.networking
  ]
}