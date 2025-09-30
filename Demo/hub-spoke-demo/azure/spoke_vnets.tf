# Spoke VNets Infrastructure
# Spoke1 and Spoke2 VNets with test VMs for validating traffic flow through security inspection

# Spoke1 Virtual Network
resource "azurerm_virtual_network" "spoke1" {
  name                = "vnet-${var.resource_prefix}-spoke1-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke1.location
  resource_group_name = azurerm_resource_group.spoke1.name
  address_space       = [var.spoke1_vnet_cidr]
  tags = merge(var.common_tags, {
    Spoke = "Spoke1"
  })
}

# Spoke1 Private Subnet
resource "azurerm_subnet" "spoke1_private" {
  name                 = "subnet-${var.resource_prefix}-spoke1-private"
  resource_group_name  = azurerm_resource_group.spoke1.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = [var.spoke1_private_subnet_cidr]
}

# Spoke2 Virtual Network
resource "azurerm_virtual_network" "spoke2" {
  name                = "vnet-${var.resource_prefix}-spoke2-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke2.location
  resource_group_name = azurerm_resource_group.spoke2.name
  address_space       = [var.spoke2_vnet_cidr]
  tags = merge(var.common_tags, {
    Spoke = "Spoke2"
  })
}

# Spoke2 Private Subnet
resource "azurerm_subnet" "spoke2_private" {
  name                 = "subnet-${var.resource_prefix}-spoke2-private"
  resource_group_name  = azurerm_resource_group.spoke2.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = [var.spoke2_private_subnet_cidr]
}

# Network Security Group for Spoke Subnets
resource "azurerm_network_security_group" "spoke_private" {
  name                = "nsg-${var.resource_prefix}-spoke-private-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke1.location
  resource_group_name = azurerm_resource_group.spoke1.name
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

# Network Security Group for Spoke2 Subnet
resource "azurerm_network_security_group" "spoke2_private" {
  name                = "nsg-${var.resource_prefix}-spoke2-private-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke2.location
  resource_group_name = azurerm_resource_group.spoke2.name
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

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "spoke1_private" {
  subnet_id                 = azurerm_subnet.spoke1_private.id
  network_security_group_id = azurerm_network_security_group.spoke_private.id
}

resource "azurerm_subnet_network_security_group_association" "spoke2_private" {
  subnet_id                 = azurerm_subnet.spoke2_private.id
  network_security_group_id = azurerm_network_security_group.spoke2_private.id
}

# Network Interface for Spoke1 VM
resource "azurerm_network_interface" "spoke1_vm" {
  name                = "nic-${var.resource_prefix}-spoke1-vm-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke1.location
  resource_group_name = azurerm_resource_group.spoke1.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1_private.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network Interface for Spoke2 VM
resource "azurerm_network_interface" "spoke2_vm" {
  name                = "nic-${var.resource_prefix}-spoke2-vm-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke2.location
  resource_group_name = azurerm_resource_group.spoke2.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke2_private.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Spoke1 Test VM
resource "azurerm_linux_virtual_machine" "spoke1" {
  name                            = "vm-${var.resource_prefix}-spoke1-${var.common_tags.Environment}"
  location                        = azurerm_resource_group.spoke1.location
  resource_group_name             = azurerm_resource_group.spoke1.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password
  tags = merge(var.common_tags, {
    Purpose = "Test VM Spoke1"
  })

  network_interface_ids = [
    azurerm_network_interface.spoke1_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  # Install basic networking tools
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y net-tools curl wget tcpdump nmap
    
    # Install nginx for testing
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config  
    echo "ubuntu:Cisco@123" | sudo chpasswd
    sudo systemctl restart sshd

    # Create simple index page with VM info
    echo "<h1>Spoke1 Test VM</h1><p>Private IP: $(hostname -I | cut -d' ' -f1)</p><p>Hostname: $(hostname)</p>" > /var/www/html/index.html
    EOF
  )
}

# Spoke2 Test VM
resource "azurerm_linux_virtual_machine" "spoke2" {
  name                            = "vm-${var.resource_prefix}-spoke2-${var.common_tags.Environment}"
  location                        = azurerm_resource_group.spoke2.location
  resource_group_name             = azurerm_resource_group.spoke2.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password
  tags = merge(var.common_tags, {
    Purpose = "Test VM Spoke2"
  })

  network_interface_ids = [
    azurerm_network_interface.spoke2_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  # Install basic networking tools
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y net-tools curl wget tcpdump nmap
    
    # Install nginx for testing
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config  
    echo "ubuntu:Cisco@123" | sudo chpasswd
    sudo systemctl restart sshd

    # Create simple index page with VM info
    echo "<h1>Spoke2 Test VM</h1><p>Private IP: $(hostname -I | cut -d' ' -f1)</p><p>Hostname: $(hostname)</p>" > /var/www/html/index.html
    EOF
  )
}

# Route Tables for Spoke VNets to route traffic through Security VNet
# Spoke1 Route Table
resource "azurerm_route_table" "spoke1" {
  name                = "rt-${var.resource_prefix}-spoke1-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke1.location
  resource_group_name = azurerm_resource_group.spoke1.name
  tags                = var.common_tags

  # Route to Spoke2 via Security VNet (East-West firewall)
  route {
    name                   = "spoke2-via-security"
    address_prefix         = var.spoke2_vnet_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.ftdv_eastwest_inside_ip
  }

  # Default route (internet) via Security VNet (Egress firewall) 
  route {
    name                   = "default-via-security"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.ftdv_egress_inside_ip
  }
}

# Spoke2 Route Table  
resource "azurerm_route_table" "spoke2" {
  name                = "rt-${var.resource_prefix}-spoke2-${var.common_tags.Environment}"
  location            = azurerm_resource_group.spoke2.location
  resource_group_name = azurerm_resource_group.spoke2.name
  tags                = var.common_tags

  # Route to Spoke1 via Security VNet (East-West firewall)
  route {
    name                   = "spoke1-via-security"
    address_prefix         = var.spoke1_vnet_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.ftdv_eastwest_inside_ip
  }

  # Default route (internet) via Security VNet (Egress firewall)
  route {
    name                   = "default-via-security"  
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.ftdv_egress_inside_ip
  }
}

# Associate Route Tables with Subnets
resource "azurerm_subnet_route_table_association" "spoke1_private" {
  subnet_id      = azurerm_subnet.spoke1_private.id
  route_table_id = azurerm_route_table.spoke1.id
}

resource "azurerm_subnet_route_table_association" "spoke2_private" {
  subnet_id      = azurerm_subnet.spoke2_private.id
  route_table_id = azurerm_route_table.spoke2.id
}