# resource "oci_core_network_security_group" "nsg_mgmt" {
#   compartment_id = var.compartment_id
#   vcn_id         = var.networks_list[0].vcn_id

#   display_name = "mgmt-cluster-security-group"
# }

# resource "oci_core_network_security_group_security_rule" "mgmt_rule_egress_all" {
#   network_security_group_id = oci_core_network_security_group.nsg_mgmt.id
#   direction                 = "EGRESS"
#   protocol                  = "all"
#   destination               = "0.0.0.0/0"
# }

# resource "oci_core_network_security_group_security_rule" "mgmt_rule_ingress_all" {
#   network_security_group_id = oci_core_network_security_group.nsg_mgmt.id
#   direction                 = "INGRESS"
#   protocol                  = "all"
#   source                    = "0.0.0.0/0"
# }



# resource "oci_core_network_security_group" "nsg_inside" {
#   compartment_id = var.compartment_id
#   vcn_id         = var.networks_list[1].vcn_id

#   display_name = "inside-cluster-security-group"
# }


# resource "oci_core_network_security_group_security_rule" "rule_egress_all" {
#   network_security_group_id = oci_core_network_security_group.nsg_inside.id
#   direction                 = "EGRESS"
#   protocol                  = "all"
#   destination               = "0.0.0.0/0"
# }

# resource "oci_core_network_security_group_security_rule" "rule_ingress_all" {
#   network_security_group_id = oci_core_network_security_group.nsg_inside.id
#   direction                 = "INGRESS"
#   protocol                  = "all"
#   source                    = "0.0.0.0/0"
# }
