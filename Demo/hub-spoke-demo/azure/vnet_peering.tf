# VNet Peering Configuration
# Hub-and-Spoke architecture using VNet peering for security inspection

# Peering: Security VNet <-> Spoke1 VNet
resource "azurerm_virtual_network_peering" "security_to_spoke1" {
  name                      = "peer-${var.resource_prefix}-security-to-spoke1"
  resource_group_name       = azurerm_resource_group.security.name
  virtual_network_name      = azurerm_virtual_network.security.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways         = false
}

resource "azurerm_virtual_network_peering" "spoke1_to_security" {
  name                      = "peer-${var.resource_prefix}-spoke1-to-security"
  resource_group_name       = azurerm_resource_group.spoke1.name
  virtual_network_name      = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.security.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways         = false
}

# Peering: Security VNet <-> Spoke2 VNet
resource "azurerm_virtual_network_peering" "security_to_spoke2" {
  name                      = "peer-${var.resource_prefix}-security-to-spoke2"
  resource_group_name       = azurerm_resource_group.security.name
  virtual_network_name      = azurerm_virtual_network.security.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways         = false
}

resource "azurerm_virtual_network_peering" "spoke2_to_security" {
  name                      = "peer-${var.resource_prefix}-spoke2-to-security"
  resource_group_name       = azurerm_resource_group.spoke2.name
  virtual_network_name      = azurerm_virtual_network.spoke2.name
  remote_virtual_network_id = azurerm_virtual_network.security.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways         = false
}