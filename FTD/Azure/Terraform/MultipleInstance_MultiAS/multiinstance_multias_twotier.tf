################################################################################################################################
# Terraform Template to install a Multiple FTDv in a location using BYOL AMI with Mgmt interface in a New Resource Group
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
# Resource Group Creation
################################################################################################################################


# Create a resource group
resource "azurerm_resource_group" "ftdv" {
  name     = var.RGName
  location = var.location
}
data "template_file" "startup_file" {
  template = file("ftd_startup_file.txt")
  vars = {
    fmc_ip       = var.fmc_ip
    fmc_nat_id   = var.fmc_nat_id
    }
}

################################################################################################################################
# Virtual Network and Subnet Creation
################################################################################################################################


resource "azurerm_virtual_network" "ftdv" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name
  address_space       = [join("", tolist([var.IPAddressPrefix, ".0.0/16"]))]
}

resource "azurerm_subnet" "ftdv-management" {
  name                 = "${var.prefix}-management"
  resource_group_name  = azurerm_resource_group.ftdv.name
  virtual_network_name = azurerm_virtual_network.ftdv.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".0.0/24"]))]
}

resource "azurerm_subnet" "ftdv-diagnostic" {
  name                 = "${var.prefix}-diagnostic"
  resource_group_name  = azurerm_resource_group.ftdv.name
  depends_on                = [azurerm_network_interface.ftdv-interface-management]
  virtual_network_name = azurerm_virtual_network.ftdv.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".1.0/24"]))]
}

resource "azurerm_subnet" "ftdv-outside" {
  name                 = "${var.prefix}-outside"
  resource_group_name  = azurerm_resource_group.ftdv.name
  depends_on                = [azurerm_network_interface.ftdv-interface-diagnostic]
  virtual_network_name = azurerm_virtual_network.ftdv.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".2.0/24"]))]
}

resource "azurerm_subnet" "ftdv-inside" {
  name                 = "${var.prefix}-inside"
  resource_group_name  = azurerm_resource_group.ftdv.name
  depends_on                = [azurerm_network_interface.ftdv-interface-outside]
  virtual_network_name = azurerm_virtual_network.ftdv.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".3.0/24"]))]
}


################################################################################################################################
# Route Table Creation and Route Table Association
################################################################################################################################

resource "azurerm_route_table" "FTD_NIC0" {
  name                = "${var.prefix}-RT-Subnet0"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name

}
resource "azurerm_route_table" "FTD_NIC1" {
  name                = "${var.prefix}-RT-Subnet1"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name

}
resource "azurerm_route_table" "FTD_NIC2" {
  name                = "${var.prefix}-RT-Subnet2"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name
}

resource "azurerm_route_table" "FTD_NIC3" {
  name                = "${var.prefix}-RT-Subnet3"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name
}

resource "azurerm_subnet_route_table_association" "example1" {
  subnet_id                 = azurerm_subnet.ftdv-management.id
  route_table_id            = azurerm_route_table.FTD_NIC0.id
}
resource "azurerm_subnet_route_table_association" "example2" {
  subnet_id                 = azurerm_subnet.ftdv-diagnostic.id
  route_table_id            = azurerm_route_table.FTD_NIC1.id
}
resource "azurerm_subnet_route_table_association" "example3" {
  subnet_id                 = azurerm_subnet.ftdv-outside.id
  route_table_id            = azurerm_route_table.FTD_NIC2.id
}
resource "azurerm_subnet_route_table_association" "example4" {
  subnet_id                 = azurerm_subnet.ftdv-inside.id
  route_table_id            = azurerm_route_table.FTD_NIC3.id
}


################################################################################################################################
# Network Security Group Creation
################################################################################################################################

resource "azurerm_network_security_group" "allow-all" {
    name                = "${var.prefix}-allow-all"
    location            = var.location
    resource_group_name = azurerm_resource_group.ftdv.name

    security_rule {
        name                       = "TCP-Allow-All"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
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

resource "azurerm_network_security_group" "ilb-allow-all" {
    name                = "${var.prefix}-ilb-allow-all"
    location            = var.location
    resource_group_name = azurerm_resource_group.ftdv.name

    security_rule {
        name                       = "TCP-Allow-All-Internal-Inbound"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "TCP-Allow-All-Internal-Outbound"
        priority                   = 1001
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "elb-allow-all" {
    name                = "${var.prefix}-elb-allow-all"
    location            = var.location
    resource_group_name = azurerm_resource_group.ftdv.name

    security_rule {
        name                       = "TCP-Allow-All-External-Inbound"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "TCP-Allow-All-External-Outbound"
        priority                   = 1001
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

################################################################################################################################
# Network Interface Creation, Public IP Creation and Network Security Group Association
################################################################################################################################

resource "azurerm_network_interface" "ftdv-interface-management" {
  name                      = "${var.prefix}-Nic0-${count.index}"
  count                     = var.instances
  location                  = var.location
  resource_group_name       = azurerm_resource_group.ftdv.name

  ip_configuration {
    name                          = "Nic0-${count.index}"
    subnet_id                     = azurerm_subnet.ftdv-management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ftdv-mgmt-interface[count.index].id
  }
}
resource "azurerm_network_interface" "ftdv-interface-diagnostic" {
  name                      = "${var.prefix}-Nic1-${count.index}"
  count                     = var.instances
  location                  = var.location
  resource_group_name       = azurerm_resource_group.ftdv.name

  ip_configuration {
    name                          = "Nic1-${count.index}"
    subnet_id                     = azurerm_subnet.ftdv-diagnostic.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "ftdv-interface-outside" {
  name                      = "${var.prefix}-Nic2-${count.index}"
  count                     = var.instances
  location                  = var.location
  resource_group_name       = azurerm_resource_group.ftdv.name

  ip_configuration {
    name                          = "Nic1-${count.index}"
    subnet_id                     = azurerm_subnet.ftdv-outside.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "ftdv-interface-inside" {
  name                      = "${var.prefix}-Nic3-${count.index}"
  count                     = var.instances
  location                  = var.location
  resource_group_name       = azurerm_resource_group.ftdv.name

  ip_configuration {
    name                          = "Nic1-${count.index}"
    subnet_id                     = azurerm_subnet.ftdv-inside.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "ftdv-mgmt-interface" {
    name                         = "management-public-ip-${count.index}"
    count                     = var.instances
    location                     = var.location
    resource_group_name          = azurerm_resource_group.ftdv.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface_security_group_association" "FTDv_NIC_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.ftdv-interface-management[count.index].id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}

resource "azurerm_network_interface_security_group_association" "FTDv_NIC_NSG_outside" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.ftdv-interface-outside[count.index].id
  network_security_group_id = azurerm_network_security_group.elb-allow-all.id
}

resource "azurerm_network_interface_security_group_association" "FTDv_NIC_NSG_inside" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.ftdv-interface-inside[count.index].id
  network_security_group_id = azurerm_network_security_group.ilb-allow-all.id
}

################################################################################################################################
# FTDv Instance Creation
################################################################################################################################

resource "azurerm_availability_set" "FTD-AS" {
  name                = "FTD-aset"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name
}

resource "azurerm_virtual_machine" "ftdv-instance" {
  name                  = "${var.prefix}-vm-${count.index}"
  location              = var.location
  count                 = var.instances
  resource_group_name   = azurerm_resource_group.ftdv.name
  availability_set_id = azurerm_availability_set.FTD-AS.id
  depends_on = [
    azurerm_network_interface.ftdv-interface-management,
    azurerm_network_interface.ftdv-interface-diagnostic,
    azurerm_network_interface.ftdv-interface-outside,
    azurerm_network_interface.ftdv-interface-inside
  ]
  
  
  primary_network_interface_id = azurerm_network_interface.ftdv-interface-management[count.index].id
  network_interface_ids = [azurerm_network_interface.ftdv-interface-management[count.index].id,
                                                        azurerm_network_interface.ftdv-interface-diagnostic[count.index].id,
                                                        azurerm_network_interface.ftdv-interface-outside[count.index].id,
                                                        azurerm_network_interface.ftdv-interface-inside[count.index].id]
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
    name              = "myosdisk-${count.index}"
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
# Internal LB Creation
################################################################################################################################

resource "azurerm_lb" "ftd-ilb" {
  name                = "FTD-ILB"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name
  sku                = "Standard"

  frontend_ip_configuration {
    name                 = "InternalIPAddress"
    subnet_id            = azurerm_subnet.ftdv-inside.id
    private_ip_address   = join("", tolist([var.IPAddressPrefix, ".3.100"]))
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "ILB-Backend-Pool" {
  loadbalancer_id = azurerm_lb.ftd-ilb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ILB-Backend-Address" {
  name                    = "ILB-Backend-Address-${count.index}"
  count                   = var.instances
  backend_address_pool_id = azurerm_lb_backend_address_pool.ILB-Backend-Pool.id
  virtual_network_id      = azurerm_virtual_network.ftdv.id
  ip_address              = azurerm_network_interface.ftdv-interface-inside[count.index].private_ip_address
}

resource "azurerm_lb_probe" "FTD-ILB-Probe" {
  resource_group_name = azurerm_resource_group.ftdv.name
  loadbalancer_id     = azurerm_lb.ftd-ilb.id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "ilbrule" {
  resource_group_name            = azurerm_resource_group.ftdv.name
  loadbalancer_id                = azurerm_lb.ftd-ilb.id
  name                           = "ILBRule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "InternalIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.ILB-Backend-Pool.id
  probe_id                       = azurerm_lb_probe.FTD-ILB-Probe.id
}

################################################################################################################################
# External LB Creation
################################################################################################################################
resource "azurerm_lb" "ftd-elb" {
  name                = "FTD-ELB"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name
  sku                = "Standard"

  frontend_ip_configuration {
    name                 = "ExternalIPAddress"
    public_ip_address_id = azurerm_public_ip.ELB-PublicIP.id
  }
}

resource "azurerm_public_ip" "ELB-PublicIP" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = azurerm_resource_group.ftdv.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb_backend_address_pool" "ELB-Backend-Pool" {
  loadbalancer_id = azurerm_lb.ftd-elb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ELB-Backend-Address" {
  name                    = "ELB-Backend-Address-${count.index}"
  count                   = var.instances
  backend_address_pool_id = azurerm_lb_backend_address_pool.ELB-Backend-Pool.id
  virtual_network_id      = azurerm_virtual_network.ftdv.id
  ip_address              = azurerm_network_interface.ftdv-interface-outside[count.index].private_ip_address
}

resource "azurerm_lb_probe" "FTD-ELB-Probe" {
  resource_group_name = azurerm_resource_group.ftdv.name
  loadbalancer_id     = azurerm_lb.ftd-elb.id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "elbrule" {
  resource_group_name            = azurerm_resource_group.ftdv.name
  loadbalancer_id                = azurerm_lb.ftd-elb.id
  name                           = "ELBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "ExternalIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.ELB-Backend-Pool.id
  probe_id                       = azurerm_lb_probe.FTD-ELB-Probe.id
}