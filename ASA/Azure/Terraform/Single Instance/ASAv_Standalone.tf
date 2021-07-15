# Terraform Template to install a Single ASAv in a location using BYOL AMI with Mgmt + Three interfaces in a New Resource Group
################################################################################################################################

################################################################################################################################
# Provider
################################################################################################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.56.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

################################################################################################################################
# Resource Group Creation
################################################################################################################################


# Create a resource group
resource "azurerm_resource_group" "asav" {
  name     = var.RGName
  location = var.location
}
data "template_file" "startup_file" {
  template = file(var.day-0-config)
}
################################################################################################################################
# Virtual Network and Subnet Creation
################################################################################################################################


resource "azurerm_virtual_network" "asav" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name
  address_space       = [join("", tolist([var.IPAddressPrefix, ".0.0/16"]))]
}

resource "azurerm_subnet" "asav-management" {
  name                 = "${var.prefix}-management"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".0.0/24"]))]
}

resource "azurerm_subnet" "asav-inside1" {
  name                 = "${var.prefix}-inside1"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".1.0/24"]))]
}

resource "azurerm_subnet" "asav-inside2" {
  name                 = "${var.prefix}-inside2"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".2.0/24"]))]
}

resource "azurerm_subnet" "asav-dmz" {
  name                 = "${var.prefix}-dmz"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".3.0/24"]))]
}

################################################################################################################################
# Route Table Creation and Route Table Association
################################################################################################################################

resource "azurerm_route_table" "ASA_FW_RT_management" {
  name                = "${var.prefix}-RT-Subnet0"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

}

resource "azurerm_route_table" "ASA_FW_RT_inside1" {
  name                = "${var.prefix}-RT-Subnet2"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

  route {
    name           = "Route-Subnet3-To-ASAv"
    address_prefix = join("", tolist([var.IPAddressPrefix, ".2.0/24"]))
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.asav-inside1.private_ip_address
  }

  route {
    name           = "Route-Subnet4-To-ASAv"
    address_prefix = join("", tolist([var.IPAddressPrefix, ".3.0/24"]))
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.asav-inside1.private_ip_address
  }
}

resource "azurerm_route_table" "ASA_FW_RT_inside2" {
  name                = "${var.prefix}-RT-Subnet3"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

  route {
    name           = "Route-Subnet1-To-ASAv"
    address_prefix = join("", tolist([var.IPAddressPrefix, ".1.0/24"]))
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.asav-inside2.private_ip_address
  }

  route {
    name           = "Route-Subnet4-To-ASAv"
    address_prefix = join("", tolist([var.IPAddressPrefix, ".3.0/24"]))
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.asav-inside2.private_ip_address
  }
}
resource "azurerm_route_table" "ASA_FW_RT_dmz" {
  name                = "${var.prefix}-RT-Subnet4"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

  route {
    name           = "Route-Subnet1-To-ASAv"
    address_prefix = join("", tolist([var.IPAddressPrefix, ".1.0/24"]))
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.asav-dmz.private_ip_address
  }

  route {
    name           = "Route-Subnet4-To-ASAv"
    address_prefix = join("", tolist([var.IPAddressPrefix, ".2.0/24"]))
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.asav-dmz.private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "management" {
  subnet_id                 = azurerm_subnet.asav-management.id
  route_table_id            = azurerm_route_table.ASA_FW_RT_management.id
}
resource "azurerm_subnet_route_table_association" "inside1" {
  subnet_id                 = azurerm_subnet.asav-inside1.id
  route_table_id            = azurerm_route_table.ASA_FW_RT_inside1.id
}
resource "azurerm_subnet_route_table_association" "inside2" {
  subnet_id                 = azurerm_subnet.asav-inside2.id
  route_table_id            = azurerm_route_table.ASA_FW_RT_inside2.id
}
resource "azurerm_subnet_route_table_association" "dmz" {
  subnet_id                 = azurerm_subnet.asav-dmz.id
  route_table_id            = azurerm_route_table.ASA_FW_RT_dmz.id
}

################################################################################################################################
# Network Security Group Creation
################################################################################################################################

resource "azurerm_network_security_group" "allow-all" {
    name                = "${var.prefix}-allow-all"
    location            = var.location
    resource_group_name = azurerm_resource_group.asav.name

    security_rule {
        name                       = "TCP-Allow-All"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = var.source-address
        destination_address_prefix = "*"
    }
}

################################################################################################################################
# Network Interface Creation, Public IP Creation and Network Security Group Association
################################################################################################################################

resource "azurerm_network_interface" "asav-management" {
  name                      = "${var.prefix}-management"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.asav.name

  ip_configuration {
    name                          = "management"
    subnet_id                     = azurerm_subnet.asav-management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.asav-mgmt-interface.id
  }
}

resource "azurerm_public_ip" "asav-mgmt-interface" {
    name                         = "instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.asav.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface_security_group_association" "ASAv_NIC_NSG" {
  network_interface_id      = azurerm_network_interface.asav-management.id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}


resource "azurerm_network_interface" "asav-inside1" {
  name                      = "${var.prefix}-inside1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.asav.name
  depends_on                = [azurerm_network_interface.asav-management]
  
  enable_ip_forwarding      = true
  ip_configuration {
    name                          = "inside1"
    subnet_id                     = azurerm_subnet.asav-inside1.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "asav-inside2" {
  name                      = "${var.prefix}-inside2"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.asav.name
  depends_on                = [azurerm_network_interface.asav-inside1]
  enable_ip_forwarding      = true
  ip_configuration {
    name                          = "inside2"
    subnet_id                     = azurerm_subnet.asav-inside2.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "asav-dmz" {
  name                      = "${var.prefix}-dmz"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.asav.name
  depends_on                = [azurerm_network_interface.asav-inside2]
  enable_ip_forwarding      = true
  ip_configuration {
    name                          = "dmz"
    subnet_id                     = azurerm_subnet.asav-dmz.id
    private_ip_address_allocation = "Dynamic"
  }
}

################################################################################################################################
# ASAv Instance Creation
################################################################################################################################

resource "azurerm_virtual_machine" "asav-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.asav.name
  
  depends_on = [
    azurerm_network_interface.asav-inside1,
    azurerm_network_interface.asav-inside2,
    azurerm_network_interface.asav-dmz
  ]
  
  primary_network_interface_id = azurerm_network_interface.asav-management.id
  network_interface_ids = [azurerm_network_interface.asav-management.id,azurerm_network_interface.asav-inside1.id,
                           azurerm_network_interface.asav-inside2.id,azurerm_network_interface.asav-dmz.id]
  vm_size               = var.VMSize


  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  plan {
    name = "asav-azure-byol"
    publisher = "cisco"
    product = "cisco-asav"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-asav"
    sku       = "asav-azure-byol"
    version   = var.Version
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.instancename
    admin_username = var.instanceusername
    admin_password = var.instancepassword
    custom_data = data.template_file.startup_file.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
    
  }
  
}

################################################################################################################################
# Output
################################################################################################################################
data "azurerm_public_ip" "asav-mgmt-interface" {
  name                = azurerm_public_ip.asav-mgmt-interface.name
  resource_group_name = azurerm_virtual_machine.asav-instance.resource_group_name
}
output "public_ip_address" {
  value = data.azurerm_public_ip.asav-mgmt-interface.ip_address
}
