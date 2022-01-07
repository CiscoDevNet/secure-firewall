###############
# Locals
###############
locals {

  #num_zones = length(data.google_compute_zones.available.names)
  #zone = var.zone != null && var.zone != "" ? var.zone : data.google_compute_zones.available.names[count.index % local.num_zones]

  # VM IPs
  vm_ips = [for x in google_compute_instance.ftd : x.network_interface.0.access_config.0.nat_ip]

}