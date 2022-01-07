###############
# VPC networks
###############
module "vcn-module" {
  for_each = local.networks
  source   = "oracle-terraform-modules/vcn/oci"
  version  = "3.0.0-RC1"
  # insert the 8 required variables here

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  tags           = var.tags

  # vcn parameters
  create_drg               = false
  internet_gateway_enabled = each.value.external_ip ? true : false
  lockdown_default_seclist = true
  nat_gateway_enabled      = false
  service_gateway_enabled  = true
  vcn_cidr                 = each.value.vcn_cidr
  vcn_dns_label            = "${each.value.name}dns"
  vcn_name                 = each.value.name

  # gateways parameters
  drg_display_name = "${each.value.name}-drg"

  # routing rules

  # internet_gateway_route_rules = var.internet_gateway_route_rules 
  # nat_gateway_route_rules      = local.nat_gateway_route_rules 
}


resource "oci_core_subnet" "vcn-subnet" {
  for_each = local.networks
  # Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn-module[each.value.name].vcn_id
  cidr_block     = each.value.subnet_cidr

  # Optional
  route_table_id    = module.vcn-module[each.value.name].ig_route_id
  security_list_ids = [oci_core_security_list.allow_all_security[each.value.name].id]
  display_name      = "${each.value.name}-subnet"
}


resource "oci_core_security_list" "allow_all_security" {
  for_each       = local.networks
  compartment_id = var.compartment_id
  vcn_id         = module.vcn-module[each.value.name].vcn_id

  display_name = "AllowAll"
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}