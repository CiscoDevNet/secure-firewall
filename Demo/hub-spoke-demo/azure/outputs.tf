# Azure Deployment Outputs
# Key information for the Azure VNet Peering + FTDv architecture

output "security_vnet_id" {
  description = "Security VNet ID"
  value       = azurerm_virtual_network.security.id
}

output "security_vnet_cidr" {
  description = "Security VNet CIDR block"
  value       = var.security_vnet_cidr
}

output "spoke1_vnet_id" {
  description = "Spoke1 VNet ID"
  value       = azurerm_virtual_network.spoke1.id
}

output "spoke1_vnet_cidr" {
  description = "Spoke1 VNet CIDR block"
  value       = var.spoke1_vnet_cidr
}

output "spoke2_vnet_id" {
  description = "Spoke2 VNet ID"
  value       = azurerm_virtual_network.spoke2.id
}

output "spoke2_vnet_cidr" {
  description = "Spoke2 VNet CIDR block"
  value       = var.spoke2_vnet_cidr
}

output "spoke1_vm_private_ip" {
  description = "Private IP address of Spoke1 test VM"
  value       = azurerm_network_interface.spoke1_vm.private_ip_address
}

output "spoke2_vm_private_ip" {
  description = "Private IP address of Spoke2 test VM"
  value       = azurerm_network_interface.spoke2_vm.private_ip_address
}

# FTDv Management IPs (when properly deployed)
output "ftdv_management_ips" {
  description = "FTDv firewall management IP addresses"
  value = {
    egress_mgmt_ip   = var.ftdv_egress_management_ip
    ingress_mgmt_ip  = var.ftdv_ingress_management_ip
    eastwest_mgmt_ip = var.ftdv_eastwest_management_ip
  }
}

output "ftdv_management_public_ips" {
  description = "FTDv firewall management public IP addresses"
  value = {
    egress_mgmt_public_ip   = azurerm_public_ip.ftdv_egress_mgmt.ip_address
    ingress_mgmt_public_ip  = azurerm_public_ip.ftdv_ingress_mgmt.ip_address
    eastwest_mgmt_public_ip = azurerm_public_ip.ftdv_eastwest_mgmt.ip_address
  }
}

output "ftdv_outside_public_ips" {
  description = "FTDv firewall outside interface public IP addresses"
  value = {
    egress_outside_public_ip   = azurerm_public_ip.ftdv_egress_outside.ip_address
    ingress_outside_public_ip  = azurerm_public_ip.ftdv_ingress_outside.ip_address
    eastwest_outside_public_ip = azurerm_public_ip.ftdv_eastwest_outside.ip_address
  }
}

output "subnet_cidrs" {
  description = "All subnet CIDR blocks"
  value = {
    management_subnet = var.management_subnet_cidr
    diagnostic_subnet = var.diagnostic_subnet_cidr
    outside_subnet    = var.outside_subnet_cidr
    inside_subnet     = var.inside_subnet_cidr
    spoke1_subnet     = var.spoke1_private_subnet_cidr
    spoke2_subnet     = var.spoke2_private_subnet_cidr
  }
}

output "route_table_info" {
  description = "VNet peering route table information"
  value = {
    security_outside_route_table = azurerm_route_table.outside.id
    security_inside_route_table  = azurerm_route_table.inside.id
    spoke1_route_table          = azurerm_route_table.spoke1.id
    spoke2_route_table          = azurerm_route_table.spoke2.id
  }
}

output "vnet_peering_info" {
  description = "VNet peering connection information"
  value = {
    security_to_spoke1 = azurerm_virtual_network_peering.security_to_spoke1.id
    spoke1_to_security = azurerm_virtual_network_peering.spoke1_to_security.id
    security_to_spoke2 = azurerm_virtual_network_peering.security_to_spoke2.id
    spoke2_to_security = azurerm_virtual_network_peering.spoke2_to_security.id
  }
}

output "deployment_summary" {
  description = "Summary of Azure deployment architecture"
  value = {
    architecture   = "Azure VNet Peering with Cisco FTDv centralized inspection"
    security_model = "Hub-and-spoke with security VNet inspection"
    firewall_count = 3
    firewall_types = ["Egress", "Ingress", "East-West"]
    spoke_count    = 2
    test_vms       = 2
  }
}