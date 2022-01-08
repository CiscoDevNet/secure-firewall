###############
# VPC networks
###############
module "vcn-module" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.0.0-RC1"
  # insert the 8 required variables here

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  tags           = var.tags

  # vcn parameters
  create_drg               = true
  internet_gateway_enabled = true
  lockdown_default_seclist = true
  nat_gateway_enabled      = true
  service_gateway_enabled  = true
  vcn_cidr                 = var.mangement_vcn_cidr_block
  vcn_dns_label            = "${var.mangement_vcn_display_name}dns"
  vcn_name                 = var.mangement_vcn_display_name

  # gateways parameters
  drg_display_name = "${var.mangement_vcn_display_name}-drg"

  # routing rules

  # internet_gateway_route_rules = var.internet_gateway_route_rules # this module input shows how to pass routing information to the vcn module through  Variable Input. Can be initialized in a *.tfvars or *.auto.tfvars file
  # nat_gateway_route_rules      = local.nat_gateway_route_rules    # this module input shows how to pass routing information to the vcn module through Local Values.
}


resource "oci_core_subnet" "vcn-subnet" {
  # Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn-module.vcn_id
  cidr_block     = var.mangement_subnet_cidr_block

  # Optional
  route_table_id    = module.vcn-module.ig_route_id
  security_list_ids = [oci_core_security_list.allow_all_security.id]
  display_name      = "${var.label_prefix}-${var.mangement_vcn_display_name}-subnet"
}


resource "oci_core_security_list" "allow_all_security" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn-module.vcn_id

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