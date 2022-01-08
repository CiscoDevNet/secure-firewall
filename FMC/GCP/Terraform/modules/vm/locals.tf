###############
# Locals
###############
locals {
  # Number of zones given a region
  num_zones = length(data.google_compute_zones.available.names)
  # VM IPs
  vm_ips = try([google_compute_instance.fmc[*].network_interface.0.access_config.0.nat_ip], [])
}