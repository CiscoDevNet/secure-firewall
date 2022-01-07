################################################################################################################################
# Terraform Template to install a Single FTDv in a location using BYOL AMI with Mgmt interface in a New Resource Group
################################################################################################################################

################################################################################################################################
# Provider
################################################################################################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.53.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

################################################################################################################################
# Data
################################################################################################################################


data "azurerm_resource_group" "rg" {
  name     = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vn_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "management_subnet" {
  name                 = var.management_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
}

data "azurerm_subnet" "diagnostic_subnet" {
  name                 = var.diagnostic_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
}

data "azurerm_subnet" "outside_subnet" {
  name                 = var.outside_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
}

data "azurerm_subnet" "inside_subnet" {
  name                 = var.inside_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
}

data "template_file" "startup_file" {
  template = file("ftd_startup_file.txt")
}


################################################################################################################################
# Network Security Group Creation
################################################################################################################################

resource "azurerm_network_security_group" "allow-all" {
    name                = "${var.prefix}-allow-all"
    location            = var.location
    resource_group_name = var.rg_name

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
    security_rule {
        name                       = "Outbound-Allow-All"
        priority                   = 1002
        direction                  = "Outbound"
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

resource "azurerm_network_interface" "ftdv-interface-management" {
  name                      = "${var.prefix}-Nic0"
  location                  = var.location
  resource_group_name       = var.rg_name

  ip_configuration {
    name                          = "Nic0"
    subnet_id                     = data.azurerm_subnet.management_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ftdv-mgmt-interface.id
  }
}
resource "azurerm_network_interface" "ftdv-interface-diagnostic" {
  name                      = "${var.prefix}-Nic1"
  location                  = var.location
  resource_group_name       = var.rg_name
  depends_on                = [azurerm_network_interface.ftdv-interface-management]
  ip_configuration {
    name                          = "Nic1"
    subnet_id                     = data.azurerm_subnet.diagnostic_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "ftdv-interface-outside" {
  name                      = "${var.prefix}-Nic2"
  location                  = var.location
  resource_group_name       = var.rg_name
  depends_on                = [azurerm_network_interface.ftdv-interface-diagnostic]
  ip_configuration {
    name                          = "Nic2"
    subnet_id                     = data.azurerm_subnet.outside_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ftdv-outside-interface.id
  }
}
resource "azurerm_network_interface" "ftdv-interface-inside" {
  name                      = "${var.prefix}-Nic3"
  location                  = var.location
  resource_group_name       = var.rg_name
  depends_on                = [azurerm_network_interface.ftdv-interface-outside]
  ip_configuration {
    name                          = "Nic3"
    subnet_id                     = data.azurerm_subnet.inside_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "ftdv-mgmt-interface" {
    name                         = "management-public-ip"
    location                     = var.location
    resource_group_name          = var.rg_name
    allocation_method            = "Dynamic"
}
resource "azurerm_public_ip" "ftdv-outside-interface" {
    name                         = "outside-public-ip"
    location                     = var.location
    resource_group_name          = var.rg_name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface_security_group_association" "FTDv_NIC0_NSG" {
  network_interface_id      = azurerm_network_interface.ftdv-interface-management.id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}
resource "azurerm_network_interface_security_group_association" "FTDv_NIC1_NSG" {
  network_interface_id      = azurerm_network_interface.ftdv-interface-diagnostic.id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}
resource "azurerm_network_interface_security_group_association" "FTDv_NIC2_NSG" {
  network_interface_id      = azurerm_network_interface.ftdv-interface-outside.id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}
resource "azurerm_network_interface_security_group_association" "FTDv_NIC3_NSG" {
  network_interface_id      = azurerm_network_interface.ftdv-interface-inside.id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}
################################################################################################################################
# FTDv Instance Creation
################################################################################################################################

resource "azurerm_virtual_machine" "ftdv-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = var.rg_name
  
  depends_on = [
    azurerm_network_interface.ftdv-interface-management,
    azurerm_network_interface.ftdv-interface-diagnostic,
    azurerm_network_interface.ftdv-interface-outside,
    azurerm_network_interface.ftdv-interface-inside
  ]
  
  primary_network_interface_id = azurerm_network_interface.ftdv-interface-management.id
  network_interface_ids = [azurerm_network_interface.ftdv-interface-management.id,
                                                        azurerm_network_interface.ftdv-interface-diagnostic.id,
                                                        azurerm_network_interface.ftdv-interface-outside.id,
                                                        azurerm_network_interface.ftdv-interface-inside.id]
  vm_size               = var.VMSize


  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  plan {
    name = "ftdv-azure-byol"
    publisher = "cisco"
    product = "cisco-ftdv"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-ftdv"
    sku       = "ftdv-azure-byol"
    version   = var.Version
  }
  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    admin_username = var.username
    admin_password = var.password
    computer_name  = var.instancename
    custom_data = data.template_file.startup_file.rendered

  }
  os_profile_linux_config {
    disable_password_authentication = false

  }

}

################################################################################################################################
# Output
################################################################################################################################
data "azurerm_public_ip" "ftdv-mgmt-interface" {
  name                = azurerm_public_ip.ftdv-mgmt-interface.name
  resource_group_name = azurerm_virtual_machine.ftdv-instance.resource_group_name
}
output "public_ip_address" {
  value = data.azurerm_public_ip.ftdv-mgmt-interface.ip_address
}
