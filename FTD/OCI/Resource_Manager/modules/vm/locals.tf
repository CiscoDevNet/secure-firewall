###############
# Locals
###############
locals {

  ADs = [
    // Iterate through data.oci_identity_availability_domains.ads and create a list containing AD names
    for i in data.oci_identity_availability_domains.ads.availability_domains : i.name
  ]
}