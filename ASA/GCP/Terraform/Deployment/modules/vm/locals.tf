###############
# Locals
###############
locals {

  # VM IPs
  vm_ips = [for x in google_compute_instance.asa : x.network_interface.0.access_config.0.nat_ip]

  # compute image and startup script are used for debugging LB with an image such as debian-10.
  compute_image  = var.compute_image == "" ? data.google_compute_image.asa.self_link : var.compute_image
  startup_script = var.startup_script == "" ? data.template_file.startup_script.rendered : var.startup_script
}