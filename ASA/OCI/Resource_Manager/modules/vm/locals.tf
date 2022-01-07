###############
# Locals
###############
locals {

  # VM IPs
  #vm_ips   = flatten([for x in oci_core_instance.asav : x.*.public_ip])
  userdata = var.startup_script == "" ? data.template_file.userdata.rendered : var.startup_script

  ADs = [
    // Iterate through data.oci_identity_availability_domains.ads and create a list containing AD names
    for i in data.oci_identity_availability_domains.ads.availability_domains : i.name
  ]
}