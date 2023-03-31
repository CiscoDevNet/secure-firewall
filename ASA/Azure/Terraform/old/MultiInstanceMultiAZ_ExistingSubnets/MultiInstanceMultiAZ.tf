############################################################################################################################
# Terraform Template to install a ASAv using BYOL in Multiple AZ using BYOL Image with Mgmt + Three Subnets
############################################################################################################################

#########################################################################################################################
# Providers
#########################################################################################################################

provider "azurerm" {
  features {}
}

#####################################################################################################################
# Variables 
#####################################################################################################################

variable "location" {
  default     = "eastus2"
  description = "Azure region"
}

variable "prefix" {
  default     = "cisco-ASAv"
  description = "Prefix to prepend resource names"
}

variable "rg_name" {
  description = "Azure Resource Group"
}

variable "vn_name" {
  description = "Existing Virtual Network Name"
}

variable "source_address" {
  default     = "*"
  description = "Limit the Management access to specific source"
}

variable "azs" {
  default = [
    "1",
    "2",
    "3"
  ]
  description = "Azure Availability Zones"
}

variable "instances" {
  default     = 2
  description = "Number of ASAv instances"
}

variable "vm_size" {
  default     = "Standard_D3_v2"
  description = "Size of the VM for ASAv"
}

variable "instancename" {
  default     = "ASAv"
  description = "ASAv instance Name"
}

variable "username" {
  default     = "cisco"
  description = "Username for the VM OS"
}

variable "password" {
  default     = "P@$$w0rd1234"
  description = "Password for the VM OS"
  sensitive   = true
}

variable "image_version" {
  default     = "917.0.3"
  description = "Version of the ASAv"
}

variable "management_subnet"{
  description = "Management newtwork subnet"
}

variable "external_subnet"{
  description = "diagnostic newtwork subnet"
}

variable "internal_subnet"{
  description = "Outside newtwork subnet"
}

#########################################################################################################################
# Data
#########################################################################################################################

locals {
  az_distribution = chunklist(sort(flatten(chunklist(setproduct(range(var.instances), var.azs), var.instances)[0])), var.instances)[1]
}

data "azurerm_resource_group" "rg" {
  name     = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vn_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "management" {
  name                 = var.management_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
}

data "azurerm_subnet" "external" {
  name                 = var.external_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
}

data "azurerm_subnet" "internal" {
  name                 = var.internal_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
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
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "ilb-allow-all" {
  name                = "${var.prefix}-ilb-allow-all"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "TCP-Allow-All-Internal-Inbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.source_address
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
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "elb-allow-all" {
  name                = "${var.prefix}-elb-allow-all"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "TCP-Allow-All-External-Inbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.source_address
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
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
}


################################################################################################################################
# Network Interface Creation, Public IP Creation and Network Security Group Association
################################################################################################################################

resource "azurerm_public_ip" "asav-mgmt-interface" {
  name                = "${var.prefix}-instance-public-ip%{if var.instances > 1}${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  sku                 = var.instances > 1 ? "Standard" : "Basic"
  resource_group_name = var.rg_name
  allocation_method   = var.instances > 1 ? "Static" : "Dynamic"
}

resource "azurerm_network_interface" "asav-mgmt" {
  name                = "${var.prefix}-mgmt%{if var.instances > 1}${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "mgmt%{if var.instances > 1}${count.index}%{endif}"
    subnet_id                     = data.azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.asav-mgmt-interface[count.index].id
  }
}


resource "azurerm_network_interface_security_group_association" "ASAv_MGMT_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.asav-mgmt[count.index].id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}


resource "azurerm_network_interface" "asav-outside" {
  name                 = "${var.prefix}-outside%{if var.instances > 1}${count.index}%{endif}"
  count                = var.instances
  location             = var.location
  resource_group_name  = var.rg_name
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "Outside%{if var.instances > 1}${count.index}%{endif}"
    subnet_id                     = data.azurerm_subnet.external.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ASAv_Outside_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.asav-outside[count.index].id
  network_security_group_id = azurerm_network_security_group.elb-allow-all.id
}

resource "azurerm_network_interface" "asav-inside" {
  name                 = "${var.prefix}-inside%{if var.instances > 1}${count.index}%{endif}"
  count                = var.instances
  location             = var.location
  resource_group_name  = var.rg_name
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "Inside%{if var.instances > 1}${count.index}%{endif}"
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ASAv_Inside_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.asav-inside[count.index].id
  network_security_group_id = azurerm_network_security_group.ilb-allow-all.id
}

################################################################################################################################
# ASAv Instance Creation
################################################################################################################################

resource "azurerm_virtual_machine" "asav-instance" {
  name                = "${var.prefix}-vm%{if var.instances > 1}${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  resource_group_name = var.rg_name

  primary_network_interface_id = azurerm_network_interface.asav-mgmt[count.index].id
  network_interface_ids = [azurerm_network_interface.asav-mgmt[count.index].id, azurerm_network_interface.asav-outside[count.index].id,
  azurerm_network_interface.asav-inside[count.index].id]
  vm_size = var.vm_size


  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  plan {
    name      = "asav-azure-byol"
    publisher = "cisco"
    product   = "cisco-asav"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-asav"
    sku       = "asav-azure-byol"
    version   = var.image_version
  }
  storage_os_disk {
    name              = "${var.prefix}-myosdisk%{if var.instances > 1}${count.index}%{endif}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.instancename}%{if var.instances > 1}${count.index}%{endif}"
    admin_username = var.username
    admin_password = var.password
    custom_data    = templatefile("ASA_Running_Config.txt", {})
  }
  os_profile_linux_config {
    disable_password_authentication = false

  }
  zones = var.instances == 1 ? [] : [local.az_distribution[count.index]]
}

################################################################################################################################
# Internal LB Creation
################################################################################################################################

resource "azurerm_lb" "asa-ilb" {
  count               = var.instances > 1 ? 1 : 0
  name                = "ASA-ILB"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "InternalIPAddress"
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address            = cidrhost(data.azurerm_subnet.internal.address_prefix, 100)
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "ILB-Backend-Pool" {
  count           = var.instances > 1 ? 1 : 0
  loadbalancer_id = azurerm_lb.asa-ilb[0].id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ILB-Backend-Address" {
  count                   = var.instances > 1 ? var.instances : 0
  name                    = "ILB-Backend-Address%{if var.instances > 1}${count.index}%{endif}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ILB-Backend-Pool[0].id
  virtual_network_id      = data.azurerm_virtual_network.vnet.id
  ip_address              = azurerm_network_interface.asav-inside[count.index].private_ip_address
}

resource "azurerm_lb_probe" "ASA-ILB-Probe" {
  count               = var.instances > 1 ? 1 : 0
  loadbalancer_id     = azurerm_lb.asa-ilb[0].id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "ilbrule" {
  count                          = var.instances > 1 ? 1 : 0
  loadbalancer_id                = azurerm_lb.asa-ilb[0].id
  name                           = "ILBRule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "InternalIPAddress"
  backend_address_pool_ids        = azurerm_lb_backend_address_pool.ILB-Backend-Pool[0].id
  probe_id                       = azurerm_lb_probe.ASA-ILB-Probe[0].id
}

################################################################################################################################
# External LB Creation
################################################################################################################################

resource "azurerm_public_ip" "ELB-PublicIP" {
  count               = var.instances > 1 ? 1 : 0
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "asa-elb" {
  count               = var.instances > 1 ? 1 : 0
  name                = "ASA-ELB"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "ExternalIPAddress"
    public_ip_address_id = azurerm_public_ip.ELB-PublicIP[0].id
  }
}

resource "azurerm_lb_backend_address_pool" "ELB-Backend-Pool" {
  count           = var.instances > 1 ? 1 : 0
  loadbalancer_id = azurerm_lb.asa-elb[0].id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ELB-Backend-Address" {
  count                   = var.instances > 1 ? var.instances : 0
  name                    = "ELB-Backend-Address%{if var.instances > 1}${count.index}%{endif}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ELB-Backend-Pool[0].id
  virtual_network_id      = data.azurerm_virtual_network.vnet.id
  ip_address              = azurerm_network_interface.asav-outside[count.index].private_ip_address
}

resource "azurerm_lb_probe" "ASA-ELB-Probe" {
  count               = var.instances > 1 ? 1 : 0
 // resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.asa-elb[0].id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "elbrule" {
  count                          = var.instances > 1 ? 1 : 0
  loadbalancer_id                = azurerm_lb.asa-elb[0].id
  name                           = "ELBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "ExternalIPAddress"
  backend_address_pool_ids        = azurerm_lb_backend_address_pool.ELB-Backend-Pool[0].id
  probe_id                       = azurerm_lb_probe.ASA-ELB-Probe[0].id
}

##################################################################################################################################
#Output
##################################################################################################################################

output "ASAv_Instance_Public_IPs" {
  value = azurerm_public_ip.asav-mgmt-interface[*].ip_address
}
