module "fmc-1" {
  source                    = "../../"
  num_instances             = var.num_instances
  project_id                = var.project_id
  region                    = var.region
  network                   = var.network
  subnet                    = var.subnet
  network_subnet_cidr_range = var.network_subnet_cidr_range
  appliance_ips             = var.appliance_ips
  vm_instance_labels        = var.vm_instance_labels
  vm_instance_tags          = var.vm_instance_tags
  vm_machine_type           = var.vm_machine_type
  cisco_product_version     = var.cisco_product_version
  admin_ssh_pub_key         = var.admin_ssh_pub_key
  day_0_config              = var.day_0_config
  hostname                  = var.hostname
  admin_password            = var.admin_password
}