###############
# Data Sources
###############
# ------ Get the Tenancy ID and ADs
data "oci_identity_availability_domains" "ads" {
  #Required
  compartment_id = var.tenancy_ocid
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/${var.day_0_config}")
  #template = var.day_0_config
  vars = {
    enable_password = var.enable_password
  }
}


# ------ Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID" {
  compartment_id = var.compartment_id
  # operating_system         = var.instance_os
  # operating_system_version = var.linux_os_version

  shape = var.vm_compute_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

# # ------ Get the Oracle Tenancy ID
# data "oci_identity_tenancy" "tenancy" {
#   tenancy_id = var.tenancy_ocid
# }

# data "oci_identity_regions" "home-region" {
#   filter {
#     name   = "key"
#     values = [data.oci_identity_tenancy.tenancy.home_region_key]
#   }
# }
