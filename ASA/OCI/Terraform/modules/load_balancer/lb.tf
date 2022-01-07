locals {
  vnics_attachments = flatten([for x in data.oci_core_vnic_attachments.instance_vnics : x.vnic_attachments])
  # the mgmt vnic appears to be blank and other nics use the same name in module vm.
  # It could be the /vnicAttachments API, can be verified with OCI CLI `oci compute vnic-attachment list --compartment-id  $compartment_id`
  outside_vnic_ids   = [for x in local.vnics_attachments : x.vnic_id if x.display_name == "asav-${var.outside_network}-vnic"]
  inside_vnic_ids = [for x in local.vnics_attachments : x.vnic_id if x.display_name == "asav-${var.inside_network}-vnic"]
}

data "oci_identity_availability_domain" "ad" {
  count          = length(var.instance_ids)
  compartment_id = var.tenancy_ocid
  ad_number      = var.vm_ads_number[count.index]
}

# Gets a list of VNIC attachments on the instance
data "oci_core_vnic_attachments" "instance_vnics" {
  count               = length(var.instance_ids)
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad[count.index].name
  instance_id         = var.instance_ids[count.index]
}

# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_vnic_attachments#vnic_attachments
# the vinc order returned from OCI API are non deterministic
# we will loop through the data.oci_core_vnic_attachments.instance_vnics and find out the vnic ids. 
# We need the vnic id for provisioning oci_core_private_ips, which can be used as target_id for LB backend. 
data "oci_core_vnic" "outside_vnic" {
  count = length(var.instance_ids)
  #vnic_id = data.oci_core_vnic_attachments.instance_vnics[count.index].vnic_attachments[0]["vnic_id"]
  vnic_id = local.outside_vnic_ids[count.index]
}

data "oci_core_vnic" "inside_vnic" {
  count   = length(var.instance_ids)
  vnic_id = local.inside_vnic_ids[count.index]
}

data "oci_core_private_ips" "outside_subnet_private_ip" {
  count   = length(var.instance_ids)
  vnic_id = data.oci_core_vnic.outside_vnic[count.index].id
}


data "oci_core_private_ips" "inside_subnet_private_ip" {
  count   = length(var.instance_ids)
  vnic_id = data.oci_core_vnic.inside_vnic[count.index].id
}

############################
## External Load Balancer ##
############################

resource "oci_network_load_balancer_network_load_balancer" "external_nlb" {
  compartment_id = var.compartment_id
  subnet_id      = var.networks_map[var.outside_network].subnet_id

  is_preserve_source_destination = false
  display_name                   = "CiscoExternalPublicNLB"
  is_private                     = false
}

resource "oci_network_load_balancer_backend_set" "external-lb-backend" {
  name                     = "external-lb-backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_nlb.id
  policy                   = "FIVE_TUPLE"
  health_checker {
    port     = "22"
    protocol = "TCP"
  }
}

resource "oci_network_load_balancer_listener" "external-lb-listener" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_nlb.id
  name                     = "firewall-untrust"
  default_backend_set_name = oci_network_load_balancer_backend_set.external-lb-backend.name
  port                     = var.service_port
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend" "external-public-lb-ends" {
  count                    = length(var.instance_ids)
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_nlb.id
  backend_set_name         = oci_network_load_balancer_backend_set.external-lb-backend.name
  port                     = var.service_port
  target_id = data.oci_core_private_ips.outside_subnet_private_ip[count.index].private_ips[0]["id"]
}


# ############################
# ## Internal Load Balancer ##
# ############################

resource "oci_network_load_balancer_network_load_balancer" "internal_nlb" {
  compartment_id                 = var.compartment_id
  subnet_id                      = var.networks_map[var.inside_network].subnet_id
  is_preserve_source_destination = false
  display_name                   = "CiscoInternalNLB"
  is_private                     = true
}

resource "oci_network_load_balancer_backend_set" "internal-lb-backend" {
  name                     = "internal-lb-backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.internal_nlb.id
  policy                   = "FIVE_TUPLE"
  health_checker {
    port     = "22"
    protocol = "TCP"
  }
}

resource "oci_network_load_balancer_listener" "internal-lb-listener" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.internal_nlb.id
  name                     = "firewall-trust"
  default_backend_set_name = oci_network_load_balancer_backend_set.internal-lb-backend.name
  port                     = "0"
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend" "internal-lb-ends" {
  count                    = length(var.instance_ids)
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.internal_nlb.id
  backend_set_name         = oci_network_load_balancer_backend_set.internal-lb-backend.name
  port                     = "0"
  target_id                = data.oci_core_private_ips.inside_subnet_private_ip[count.index].private_ips[0]["id"]
}


