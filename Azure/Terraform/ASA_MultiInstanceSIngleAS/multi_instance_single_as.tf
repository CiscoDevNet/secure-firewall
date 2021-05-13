################################################################################################################################
# Terraform Template to install multiple ASAv in a location using BYOL AMI with Mgmt + Two interfaces in a New Resource Group
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
  template = file("ASA_Running_Config.txt")
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

resource "azurerm_subnet" "asav-mgmt" {
  name                 = "${var.prefix}-mgmt"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".0.0/24"]))]
}

resource "azurerm_subnet" "asav-external" {
  name                 = "${var.prefix}-external"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".1.0/24"]))]
}

resource "azurerm_subnet" "asav-internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".2.0/24"]))]
}


resource "azurerm_subnet" "asav-web" {
  name                 = "${var.prefix}-web"
  resource_group_name  = azurerm_resource_group.asav.name
  virtual_network_name = azurerm_virtual_network.asav.name
  address_prefixes       = [join("", tolist([var.IPAddressPrefix, ".3.0/24"]))]
}



################################################################################################################################
# Route Table Creation and Route Table Association
################################################################################################################################

resource "azurerm_route_table" "ASA_Mgmt" {
  name                = "${var.prefix}-mgmt"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

}

resource "azurerm_route_table" "ASA_outside" {
  name                = "${var.prefix}-outside"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

  # route {
  #   name           = "Route-Subnet1-To-ASAv"
  #   address_prefix = join("", tolist([var.IPAddressPrefix, ".2.0/24"]))
  #   next_hop_type  = "VirtualAppliance"
  #   next_hop_in_ip_address = azurerm_network_interface.asav-outside[0].private_ip_address
  # }

}
resource "azurerm_route_table" "ASA_inside" {
  name                = "${var.prefix}-inside"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

  # route {
  #   name           = "Route-Subnet1-To-ASAv"
  #   address_prefix = join("", tolist([var.IPAddressPrefix, ".1.0/24"]))
  #   next_hop_type  = "VirtualAppliance"
  #   next_hop_in_ip_address = azurerm_network_interface.asav-inside[0].private_ip_address
  # }

}



resource "azurerm_route_table" "ASA_Web_Internet" {
  name                = "${var.prefix}-webinternet"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

  route {
    name           = "Route-web-ASAv"
    address_prefix = "10.0.0.0/8"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_lb.asa-ilb.private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "RTA-WebASA" {
  subnet_id                 = azurerm_subnet.asav-web.id
  route_table_id            = azurerm_route_table.ASA_Web_Internet.id
}


resource "azurerm_subnet_route_table_association" "RTA-Mgmt" {
  subnet_id                 = azurerm_subnet.asav-mgmt.id
  route_table_id            = azurerm_route_table.ASA_Mgmt.id
}
resource "azurerm_subnet_route_table_association" "RTA-Outside" {
  subnet_id                 = azurerm_subnet.asav-external.id
  route_table_id            = azurerm_route_table.ASA_outside.id
}
resource "azurerm_subnet_route_table_association" "RTA-Inside" {
  subnet_id                 = azurerm_subnet.asav-internal.id
  route_table_id            = azurerm_route_table.ASA_inside.id
}



################################################################################################################################
# Network Security Group Creation
################################################################################################################################

resource "azurerm_network_security_group" "allow-all" {
    name                = "${var.prefix}-allow-all-${count.index}"
    count               = var.instances
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

resource "azurerm_network_security_group" "ilb-allow-all" {
    name                = "${var.prefix}-ilb-allow-all"
    location            = var.location
    resource_group_name = azurerm_resource_group.asav.name

    security_rule {
        name                       = "TCP-Allow-All-Internal-Inbound"
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
        name                       = "TCP-Allow-All-Internal-Outbound"
        priority                   = 1001
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = var.source-address
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "elb-allow-all" {
    name                = "${var.prefix}-elb-allow-all"
    location            = var.location
    resource_group_name = azurerm_resource_group.asav.name

    security_rule {
        name                       = "TCP-Allow-All-External-Inbound"
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
        name                       = "TCP-Allow-All-External-Outbound"
        priority                   = 1001
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

resource "azurerm_network_interface" "asav-mgmt" {
  name                      = "${var.prefix}-mgmt-${count.index}"
  count                     = var.instances
  location                  = var.location
  resource_group_name       = azurerm_resource_group.asav.name

  ip_configuration {
    name                          = "mgmt-${count.index}"
    subnet_id                     = azurerm_subnet.asav-mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.asav-mgmt-interface[count.index].id
  }
}

resource "azurerm_public_ip" "asav-mgmt-interface" {
    name                         = "instance-public-ip-${count.index}"
    count                        = var.instances
    location                     = var.location
    resource_group_name          = azurerm_resource_group.asav.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface_security_group_association" "ASAv_MGMT_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.asav-mgmt[count.index].id
  network_security_group_id = azurerm_network_security_group.allow-all[count.index].id
}


resource "azurerm_network_interface" "asav-outside" {
  name                      = "${var.prefix}-outside-${count.index}"
  count                     = var.instances
  location                  = var.location
  resource_group_name       = azurerm_resource_group.asav.name
  enable_ip_forwarding      = true
  ip_configuration {
    name                          = "Outside-${count.index}"
    subnet_id                     = azurerm_subnet.asav-external.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ASAv_Outside_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.asav-outside[count.index].id
  network_security_group_id = azurerm_network_security_group.elb-allow-all.id
}

resource "azurerm_network_interface" "asav-inside" {
  name                      = "${var.prefix}-inside-${count.index}"
  count                     = var.instances
  location                  = var.location
  resource_group_name       = azurerm_resource_group.asav.name
  enable_ip_forwarding      = true
  ip_configuration {
    name                          = "Inside-${count.index}"
    subnet_id                     = azurerm_subnet.asav-internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ASAv_Inside_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.asav-inside[count.index].id
  network_security_group_id = azurerm_network_security_group.ilb-allow-all.id
}


################################################################################################################################
# Network and Public IP for Test VM
################################################################################################################################

resource "azurerm_network_interface" "windserverinterface" {
  name                = "server-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name

  ip_configuration {
    name                          = "serverinterface"
    subnet_id                     = azurerm_subnet.asav-web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.asav-web-mgmt-interface.id
  }
}

resource "azurerm_public_ip" "asav-web-mgmt-interface" {
    name                         = "asav-web-mgmt-interface"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.asav.name
    allocation_method            = "Dynamic"
}
################################################################################################################################
# ASAv Instance Creation
################################################################################################################################

resource "azurerm_virtual_machine" "asav-instance" {
  name                  = "${var.prefix}-vm-${count.index}"
  count                 = var.instances
  location              = var.location
  resource_group_name   = azurerm_resource_group.asav.name
  primary_network_interface_id = azurerm_network_interface.asav-mgmt[count.index].id
  network_interface_ids = [azurerm_network_interface.asav-mgmt[count.index].id,azurerm_network_interface.asav-outside[count.index].id,
                           azurerm_network_interface.asav-inside[count.index].id]
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
    name              = "myosdisk1-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.instancename
    admin_username = var.username
    admin_password = var.password
    custom_data = data.template_file.startup_file.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
    
  }
  
}

################################################################################################################################
# Test VM Creation in Web Subnet 
################################################################################################################################
resource "azurerm_windows_virtual_machine" "example" {
  name                = "wind-machine"
  resource_group_name = azurerm_resource_group.asav.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  
  network_interface_ids = [
    azurerm_network_interface.windserverinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
################################################################################################################################
# Internal LB Creation
################################################################################################################################
resource "azurerm_lb" "asa-ilb" {
  name                = "ASA-ILB"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name
  sku                = "Standard"

  frontend_ip_configuration {
    name                 = "InternalIPAddress"
    subnet_id            = azurerm_subnet.asav-internal.id
    private_ip_address   = join("", tolist([var.IPAddressPrefix, ".2.100"]))
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "ILB-Backend-Pool" {
  loadbalancer_id = azurerm_lb.asa-ilb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ILB-Backend-Address" {
  name                    = "ILB-Backend-Address-${count.index}"
  count                   = var.instances
  backend_address_pool_id = azurerm_lb_backend_address_pool.ILB-Backend-Pool.id
  virtual_network_id      = azurerm_virtual_network.asav.id
  ip_address              = azurerm_network_interface.asav-inside[count.index].private_ip_address
}

resource "azurerm_lb_probe" "ASA-ILB-Probe" {
  resource_group_name = azurerm_resource_group.asav.name
  loadbalancer_id     = azurerm_lb.asa-ilb.id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "ilbrule" {
  resource_group_name            = azurerm_resource_group.asav.name
  loadbalancer_id                = azurerm_lb.asa-ilb.id
  name                           = "ILBRule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "InternalIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.ILB-Backend-Pool.id
  probe_id                       = azurerm_lb_probe.ASA-ILB-Probe.id
}

################################################################################################################################
# External LB Creation
################################################################################################################################
resource "azurerm_lb" "asa-elb" {
  name                = "ASA-ELB"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name
  sku                = "Standard"

  frontend_ip_configuration {
    name                 = "ExternalIPAddress"
    public_ip_address_id = azurerm_public_ip.ELB-PublicIP.id
  }
}

resource "azurerm_public_ip" "ELB-PublicIP" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = azurerm_resource_group.asav.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb_backend_address_pool" "ELB-Backend-Pool" {
  loadbalancer_id = azurerm_lb.asa-elb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ELB-Backend-Address" {
  name                    = "ELB-Backend-Address-${count.index}"
  count                   = var.instances
  backend_address_pool_id = azurerm_lb_backend_address_pool.ELB-Backend-Pool.id
  virtual_network_id      = azurerm_virtual_network.asav.id
  ip_address              = azurerm_network_interface.asav-outside[count.index].private_ip_address
}

resource "azurerm_lb_probe" "ASA-ELB-Probe" {
  resource_group_name = azurerm_resource_group.asav.name
  loadbalancer_id     = azurerm_lb.asa-elb.id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "elbrule" {
  resource_group_name            = azurerm_resource_group.asav.name
  loadbalancer_id                = azurerm_lb.asa-elb.id
  name                           = "ELBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "ExternalIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.ELB-Backend-Pool.id
  probe_id                       = azurerm_lb_probe.ASA-ELB-Probe.id
}
