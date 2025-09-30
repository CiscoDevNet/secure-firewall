# Security VNet Infrastructure
# This VNet hosts the Cisco FTDv firewalls for centralized security inspection

# Security Virtual Network
resource "azurerm_virtual_network" "security" {
  name                = "vnet-${var.resource_prefix}-security-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  address_space       = [var.security_vnet_cidr]
  tags                = var.common_tags
}

# Management Subnet - For FTDv management interfaces
resource "azurerm_subnet" "management" {
  name                 = "subnet-${var.resource_prefix}-management"
  resource_group_name  = azurerm_resource_group.security.name
  virtual_network_name = azurerm_virtual_network.security.name
  address_prefixes     = [var.management_subnet_cidr]

  # Allow management traffic from NSG
  service_endpoints = ["Microsoft.Storage"]
}

# Diagnostic Subnet - For FTDv diagnostic interfaces
resource "azurerm_subnet" "diagnostic" {
  name                 = "subnet-${var.resource_prefix}-diagnostic"
  resource_group_name  = azurerm_resource_group.security.name
  virtual_network_name = azurerm_virtual_network.security.name
  address_prefixes     = [var.diagnostic_subnet_cidr]
}

# Outside Subnet - For FTDv outside/untrust interfaces
resource "azurerm_subnet" "outside" {
  name                 = "subnet-${var.resource_prefix}-outside"
  resource_group_name  = azurerm_resource_group.security.name
  virtual_network_name = azurerm_virtual_network.security.name
  address_prefixes     = [var.outside_subnet_cidr]
}

# Inside Subnet - For FTDv inside/trust interfaces
resource "azurerm_subnet" "inside" {
  name                 = "subnet-${var.resource_prefix}-inside"
  resource_group_name  = azurerm_resource_group.security.name
  virtual_network_name = azurerm_virtual_network.security.name
  address_prefixes     = [var.inside_subnet_cidr]
}

# Network Security Group for Management Subnet
resource "azurerm_network_security_group" "management" {
  name                = "nsg-${var.resource_prefix}-management-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  # Allow all inbound traffic from trusted networks only
  security_rule {
    name                         = "AllowTrustedNetworksInbound"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefixes      = var.trusted_networks
    destination_address_prefix   = "*"
  }

  # Allow all outbound traffic to any destination
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Outside Subnet
resource "azurerm_network_security_group" "outside" {
  name                = "nsg-${var.resource_prefix}-outside-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  # Allow inbound traffic only from trusted networks
  security_rule {
    name                         = "AllowTrustedNetworksInbound"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefixes      = var.trusted_networks
    destination_address_prefix   = "*"
  }

  # Allow all outbound traffic to any destination
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Inside Subnet
resource "azurerm_network_security_group" "inside" {
  name                = "nsg-${var.resource_prefix}-inside-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  # Allow inbound traffic only from trusted networks
  security_rule {
    name                         = "AllowTrustedNetworksInbound"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefixes      = var.trusted_networks
    destination_address_prefix   = "*"
  }

  # Allow all outbound traffic to any destination
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Route Table for Inside Subnet
resource "azurerm_route_table" "inside" {
  name                = "rt-${var.resource_prefix}-inside-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  # NOTE: No explicit routes to spokes - let VNet peering handle direct return traffic
  # This allows return internet traffic to flow directly back to spokes via VNet peering
  # Inter-spoke traffic will be routed via East-West firewall from the spoke route tables
}

# Route Table for Outside Subnet
resource "azurerm_route_table" "outside" {
  name                = "rt-${var.resource_prefix}-outside-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  # Default route to internet via Azure's default gateway
  route {
    name           = "DefaultToInternet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

# Associate Management subnet with NSG
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

# Associate Outside subnet with NSG and Route Table
resource "azurerm_subnet_network_security_group_association" "outside" {
  subnet_id                 = azurerm_subnet.outside.id
  network_security_group_id = azurerm_network_security_group.outside.id
}

resource "azurerm_subnet_route_table_association" "outside" {
  subnet_id      = azurerm_subnet.outside.id
  route_table_id = azurerm_route_table.outside.id
}

# Associate Inside subnet with NSG and Route Table
resource "azurerm_subnet_network_security_group_association" "inside" {
  subnet_id                 = azurerm_subnet.inside.id
  network_security_group_id = azurerm_network_security_group.inside.id
}

resource "azurerm_subnet_route_table_association" "inside" {
  subnet_id      = azurerm_subnet.inside.id
  route_table_id = azurerm_route_table.inside.id
}
