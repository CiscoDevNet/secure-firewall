output "mgmt_interface" {
  value =azurerm_network_interface.ftdv-mgmt.*.id
}

output "outside_interface" {
  value = azurerm_network_interface.ftdv-outside.*.id
}

output "outside_interface_ip_address" {
  value = azurerm_network_interface.ftdv-outside.*.private_ip_address
}


output "inside_interface" {
  value =azurerm_network_interface.ftdv-inside.*.id
}

output "inside_interface_ip_address" {
  value =azurerm_network_interface.ftdv-inside.*.private_ip_address
}

output "diag_interface" {
  value =azurerm_network_interface.ftdv-diagnostic.*.id
}


output "inside_subnet" {
  value = azurerm_subnet.subnets["inside"].id
 
}

output "inside_subnet_cidr" {
  value = azurerm_subnet.subnets["inside"].address_prefix
 
}


output "virtual_network_id" {
  value = azurerm_virtual_network.ftdv.*.id
}


