# Cisco FTDv Firewall Infrastructure
# Complete Azure deployment with userdata integration

# Management Public IPs for FTDv instances
resource "azurerm_public_ip" "ftdv_egress_mgmt" {
  name                = "pip-${var.resource_prefix}-ftdv-egress-mgmt-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.common_tags, {
    Purpose = "FTDv Egress Management"
  })
}

resource "azurerm_public_ip" "ftdv_ingress_mgmt" {
  name                = "pip-${var.resource_prefix}-ftdv-ingress-mgmt-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.common_tags, {
    Purpose = "FTDv Ingress Management"
  })
}

resource "azurerm_public_ip" "ftdv_eastwest_mgmt" {
  name                = "pip-${var.resource_prefix}-ftdv-eastwest-mgmt-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.common_tags, {
    Purpose = "FTDv EastWest Management"
  })
}

# Public IPs for Outside Interfaces
resource "azurerm_public_ip" "ftdv_egress_outside" {
  name                = "pip-${var.resource_prefix}-ftdv-egress-outside-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.common_tags, {
    Purpose = "FTDv Egress Outside Interface"
  })
}

resource "azurerm_public_ip" "ftdv_ingress_outside" {
  name                = "pip-${var.resource_prefix}-ftdv-ingress-outside-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.common_tags, {
    Purpose = "FTDv Ingress Outside Interface"
  })
}

resource "azurerm_public_ip" "ftdv_eastwest_outside" {
  name                = "pip-${var.resource_prefix}-ftdv-eastwest-outside-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.common_tags, {
    Purpose = "FTDv EastWest Outside Interface"
  })
}

# Network Interfaces for Egress FTDv (4 interfaces)
resource "azurerm_network_interface" "ftdv_egress_mgmt" {
  name                = "nic-${var.resource_prefix}-ftdv-egress-mgmt-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "management"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_egress_management_ip
    public_ip_address_id          = azurerm_public_ip.ftdv_egress_mgmt.id
  }
}

resource "azurerm_network_interface" "ftdv_egress_diag" {
  name                = "nic-${var.resource_prefix}-ftdv-egress-diag-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "diagnostic"
    subnet_id                     = azurerm_subnet.diagnostic.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_egress_diagnostic_ip
  }
}

resource "azurerm_network_interface" "ftdv_egress_outside" {
  name                  = "nic-${var.resource_prefix}-ftdv-egress-outside-${var.common_tags.Environment}"
  location              = azurerm_resource_group.security.location
  resource_group_name   = azurerm_resource_group.security.name
  tags                  = var.common_tags
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "outside"
    subnet_id                     = azurerm_subnet.outside.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_egress_outside_ip
    public_ip_address_id          = azurerm_public_ip.ftdv_egress_outside.id
  }
}

resource "azurerm_network_interface" "ftdv_egress_inside" {
  name                  = "nic-${var.resource_prefix}-ftdv-egress-inside-${var.common_tags.Environment}"
  location              = azurerm_resource_group.security.location
  resource_group_name   = azurerm_resource_group.security.name
  tags                  = var.common_tags
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "inside"
    subnet_id                     = azurerm_subnet.inside.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_egress_inside_ip
  }
}

# Egress FTDv Virtual Machine
resource "azurerm_virtual_machine" "ftdv_egress" {
  name                = "vm-${var.resource_prefix}-ftdv-egress-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name

  primary_network_interface_id = azurerm_network_interface.ftdv_egress_mgmt.id
  network_interface_ids = [
    azurerm_network_interface.ftdv_egress_mgmt.id,
    azurerm_network_interface.ftdv_egress_diag.id,
    azurerm_network_interface.ftdv_egress_outside.id,
    azurerm_network_interface.ftdv_egress_inside.id,
  ]
  vm_size = var.ftdv_vm_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  plan {
    name      = "ftdv-azure-byol"
    publisher = "cisco"
    product   = "cisco-ftdv"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-ftdv"
    sku       = "ftdv-azure-byol"
    version   = var.ftd_image_version
  }

  storage_os_disk {
    name              = "${var.resource_prefix}-ftdv-egress-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "Azure-Egress-Firewall"
    admin_username = var.ftdv_admin_username
    admin_password = var.ftdv_admin_password
    custom_data = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
      admin_password = var.ftdv_admin_password
      hostname       = "Azure-Egress-Firewall"
      fmc_ip         = sccfm_ftd_device.egress-fw.hostname
      reg_key        = sccfm_ftd_device.egress-fw.reg_key
      fmc_nat_id     = sccfm_ftd_device.egress-fw.nat_id
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false    
  }

  tags = merge(var.common_tags, {
    Purpose      = "FTDv Egress Firewall"
    FirewallRole = "Egress"
  })
}

# Network Interfaces for Ingress FTDv (4 interfaces)
resource "azurerm_network_interface" "ftdv_ingress_mgmt" {
  name                = "nic-${var.resource_prefix}-ftdv-ingress-mgmt-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "management"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_ingress_management_ip
    public_ip_address_id          = azurerm_public_ip.ftdv_ingress_mgmt.id
  }
}

resource "azurerm_network_interface" "ftdv_ingress_diag" {
  name                = "nic-${var.resource_prefix}-ftdv-ingress-diag-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "diagnostic"
    subnet_id                     = azurerm_subnet.diagnostic.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_ingress_diagnostic_ip
  }
}

resource "azurerm_network_interface" "ftdv_ingress_outside" {
  name                  = "nic-${var.resource_prefix}-ftdv-ingress-outside-${var.common_tags.Environment}"
  location              = azurerm_resource_group.security.location
  resource_group_name   = azurerm_resource_group.security.name
  tags                  = var.common_tags
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "outside"
    subnet_id                     = azurerm_subnet.outside.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_ingress_outside_ip
    public_ip_address_id          = azurerm_public_ip.ftdv_ingress_outside.id
  }
}

resource "azurerm_network_interface" "ftdv_ingress_inside" {
  name                  = "nic-${var.resource_prefix}-ftdv-ingress-inside-${var.common_tags.Environment}"
  location              = azurerm_resource_group.security.location
  resource_group_name   = azurerm_resource_group.security.name
  tags                  = var.common_tags
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "inside"
    subnet_id                     = azurerm_subnet.inside.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_ingress_inside_ip
  }
}

# Ingress FTDv Virtual Machine
resource "azurerm_virtual_machine" "ftdv_ingress" {
  name                = "vm-${var.resource_prefix}-ftdv-ingress-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name

  primary_network_interface_id = azurerm_network_interface.ftdv_ingress_mgmt.id
  network_interface_ids = [
    azurerm_network_interface.ftdv_ingress_mgmt.id,
    azurerm_network_interface.ftdv_ingress_diag.id,
    azurerm_network_interface.ftdv_ingress_outside.id,
    azurerm_network_interface.ftdv_ingress_inside.id,
  ]
  vm_size = var.ftdv_vm_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  plan {
    name      = "ftdv-azure-byol"
    publisher = "cisco"
    product   = "cisco-ftdv"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-ftdv"
    sku       = "ftdv-azure-byol"
    version   = var.ftd_image_version
  }

  storage_os_disk {
    name              = "${var.resource_prefix}-ftdv-ingress-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "Azure-Ingress-Firewall"
    admin_username = var.ftdv_admin_username
    admin_password = var.ftdv_admin_password
    custom_data = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
      admin_password = var.ftdv_admin_password
      hostname       = "Azure-Ingress-Firewall"
      fmc_ip         = sccfm_ftd_device.ingress-fw.hostname
      reg_key        = sccfm_ftd_device.ingress-fw.reg_key
      fmc_nat_id     = sccfm_ftd_device.ingress-fw.nat_id
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false    
  }

  tags = merge(var.common_tags, {
    Purpose      = "FTDv Ingress Firewall"
    FirewallRole = "Ingress"
  })
}

# Network Interfaces for East-West FTDv (4 interfaces)
resource "azurerm_network_interface" "ftdv_eastwest_mgmt" {
  name                = "nic-${var.resource_prefix}-ftdv-eastwest-mgmt-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "management"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_eastwest_management_ip
    public_ip_address_id          = azurerm_public_ip.ftdv_eastwest_mgmt.id
  }
}

resource "azurerm_network_interface" "ftdv_eastwest_diag" {
  name                = "nic-${var.resource_prefix}-ftdv-eastwest-diag-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "diagnostic"
    subnet_id                     = azurerm_subnet.diagnostic.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_eastwest_diagnostic_ip
  }
}

resource "azurerm_network_interface" "ftdv_eastwest_outside" {
  name                  = "nic-${var.resource_prefix}-ftdv-eastwest-outside-${var.common_tags.Environment}"
  location              = azurerm_resource_group.security.location
  resource_group_name   = azurerm_resource_group.security.name
  tags                  = var.common_tags
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "outside"
    subnet_id                     = azurerm_subnet.outside.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_eastwest_outside_ip
    public_ip_address_id          = azurerm_public_ip.ftdv_eastwest_outside.id
  }
}

resource "azurerm_network_interface" "ftdv_eastwest_inside" {
  name                  = "nic-${var.resource_prefix}-ftdv-eastwest-inside-${var.common_tags.Environment}"
  location              = azurerm_resource_group.security.location
  resource_group_name   = azurerm_resource_group.security.name
  tags                  = var.common_tags
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "inside"
    subnet_id                     = azurerm_subnet.inside.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ftdv_eastwest_inside_ip
  }
}

# East-West FTDv Virtual Machine
resource "azurerm_virtual_machine" "ftdv_eastwest" {
  name                = "vm-${var.resource_prefix}-ftdv-eastwest-${var.common_tags.Environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name

  primary_network_interface_id = azurerm_network_interface.ftdv_eastwest_mgmt.id
  network_interface_ids = [
    azurerm_network_interface.ftdv_eastwest_mgmt.id,
    azurerm_network_interface.ftdv_eastwest_diag.id,
    azurerm_network_interface.ftdv_eastwest_outside.id,
    azurerm_network_interface.ftdv_eastwest_inside.id,
  ]
  vm_size = var.ftdv_vm_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  plan {
    name      = "ftdv-azure-byol"
    publisher = "cisco"
    product   = "cisco-ftdv"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-ftdv"
    sku       = "ftdv-azure-byol"
    version   = var.ftd_image_version
  }

  storage_os_disk {
    name              = "${var.resource_prefix}-ftdv-eastwest-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "Azure-EastWest-Firewall"
    admin_username = var.ftdv_admin_username
    admin_password = var.ftdv_admin_password
    custom_data = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
      admin_password = var.ftdv_admin_password
      hostname       = "Azure-EastWest-Firewall"
      fmc_ip         = sccfm_ftd_device.eastwest-fw.hostname
      reg_key        = sccfm_ftd_device.eastwest-fw.reg_key
      fmc_nat_id     = sccfm_ftd_device.eastwest-fw.nat_id
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false    
  }

  tags = merge(var.common_tags, {
    Purpose      = "FTDv East-West Firewall"
    FirewallRole = "EastWest"
  })
}