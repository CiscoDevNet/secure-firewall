#############################################
# Instances
#############################################
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}


resource "oci_core_instance" "ftd" {
  provider = oci
  count    = var.num_instances
  # Required
  # availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domains.ads.availability_domains[0].name)
  availability_domain = element(local.ADs, var.vm_ads_number[count.index] - 1)
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
    display_name     = "${var.hostname}-${var.networks_list[0].name}-vnic"
    assign_public_ip = var.networks_list[0].external_ip
    #subnet_id = "ocid1.subnet.oc1.us-sanjose-1.aaaaaaaaa2swnav3qxuhjih7oyxarhzvvb2oetzmxtpeurbrec2noi7u5x7q"
    subnet_id              = var.networks_list[0].subnet_id
    private_ip             = var.networks_list[0].private_ip[count.index]
    skip_source_dest_check = "true"
    #nsg_ids                = [oci_core_network_security_group.nsg_mgmt.id]
  }
  metadata = {
    ssh_authorized_keys = var.admin_ssh_pub_key
    #user_data = "${base64encode(file("${path.module}/template/oob.txt"))}"
    user_data = base64encode(data.template_file.userdata[count.index].rendered)
  }
  preserve_boot_volume = false
}

resource "oci_core_vnic_attachment" "ftd_vnic_attachment_1" {
  count = var.num_instances
  #Required
  create_vnic_details {
    subnet_id              = var.networks_list[1].subnet_id
    display_name           = "${var.hostname}-${var.networks_list[1].name}-vnic"
    skip_source_dest_check = "true"
    assign_public_ip       = var.networks_list[1].external_ip
    private_ip             = var.networks_list[1].private_ip[count.index]
    #nsg_ids                = [oci_core_network_security_group.nsg_inside.id]
  }
  instance_id = oci_core_instance.ftd[count.index].id

  #Optional
  display_name = "${var.hostname}-${var.networks_list[1].name}-vnic"
  #nic_index = 0
}

resource "oci_core_vnic_attachment" "ftd_vnic_attachment_2" {
  count = var.num_instances
  #Required
  create_vnic_details {
    subnet_id              = var.networks_list[2].subnet_id
    display_name           = "${var.hostname}-${var.networks_list[2].name}-vnic"
    skip_source_dest_check = "true"
    assign_public_ip       = var.networks_list[2].external_ip
    private_ip             = var.networks_list[2].private_ip[count.index]
  }
  instance_id = oci_core_instance.ftd[count.index].id

  #Optional
  display_name = "${var.hostname}-${var.networks_list[2].name}-vnic"
}


resource "oci_core_vnic_attachment" "ftd_vnic_attachment_3" {
  count = var.num_instances
  #Required
  create_vnic_details {
    subnet_id              = var.networks_list[3].subnet_id
    display_name           = "${var.hostname}-${var.networks_list[3].name}-vnic"
    skip_source_dest_check = "true"
    assign_public_ip       = var.networks_list[3].external_ip
    private_ip             = var.networks_list[3].private_ip[count.index]
  }
  instance_id = oci_core_instance.ftd[count.index].id

  #Optional
  display_name = "${var.hostname}-${var.networks_list[3].name}-vnic"
}


resource "oci_core_vnic_attachment" "ftd_vnic_attachment_4" {
  count = var.num_instances
  #Required
  create_vnic_details {
    subnet_id              = var.networks_list[4].subnet_id
    display_name           = "${var.hostname}-${var.networks_list[4].name}-vnic"
    skip_source_dest_check = "true"
    assign_public_ip       = var.networks_list[4].external_ip
    private_ip             = var.networks_list[4].private_ip[count.index]
  }
  instance_id = oci_core_instance.ftd[count.index].id

  #Optional
  display_name = "${var.hostname}-${var.networks_list[4].name}-vnic"
}

