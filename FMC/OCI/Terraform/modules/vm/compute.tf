#############################################
# Instances
#############################################
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}


resource "oci_core_instance" "fmc" {
  provider = oci
  count    = var.num_instances
  # Required
  availability_domain = var.multiple_ad ? data.oci_identity_availability_domains.ads.availability_domains[count.index - 1].name : data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.vm_compute_shape
  source_details {
    # market place image
    source_id = var.mp_listing_resource_id
    # orace linux image for debugging LB use cases
    #source_id   = data.oci_core_images.InstanceImageOCID.images[1].id
    source_type = "image"
    #boot_volume_size_in_gbs = "50"
  }

  # Optional
  display_name = "${var.hostname}-${count.index + 1}-${random_string.suffix.result}"
  create_vnic_details {
    display_name           = "${var.hostname}-${count.index + 1}-vnic"
    assign_public_ip       = true
    skip_source_dest_check = true
    subnet_id              = var.subnet_id
    private_ip             = var.appliance_ips[count.index]
    #nsg_ids                = [oci_core_network_security_group.nsg_mgmt.id]
  }
  metadata = {
    ssh_authorized_keys = var.admin_ssh_pub_key
    user_data           = base64encode(data.template_file.userdata[count.index].rendered)
  }
  preserve_boot_volume = false
}
