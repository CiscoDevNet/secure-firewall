# ###############
# Locals
###############
locals {
  vm_ips_ftd = [for x in google_compute_instance.ftd : x.network_interface.0.access_config.0.nat_ip]
  vm_ips_fmc = try([google_compute_instance.fmc[*].network_interface.0.access_config.0.nat_ip], [])
}