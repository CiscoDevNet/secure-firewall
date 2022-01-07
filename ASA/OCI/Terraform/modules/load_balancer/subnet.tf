# ------ Create NLB subnet
# resource "oci_core_subnet" "nlb_subnet" {
#   # required
#   compartment_id             = var.compartment_id
#   vcn_id                     = var.networks_map[var.mgmt_network].vcn_id
#   cidr_block                 = var.networks_map[var.mgmt_network].subnet_cidr

#   # optional
#   display_name               = "asa-nlb-subnet"
#   #security_list_ids          = [oci_core_security_list.allow_all_security.id]
# }
