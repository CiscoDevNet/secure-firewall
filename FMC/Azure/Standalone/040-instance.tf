#### INSTANCE CONFIGURATION ####

# Create virtual machine

resource "azurerm_windows_virtual_machine" "win10" {
  name                = var.win_virtual_machine_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "tomasz"
  admin_password      = "C!sco1234!"
  availability_set_id = azurerm_availability_set.demo.id
  network_interface_ids = [azurerm_network_interface.win.id]

  os_disk {
    name                 = "myWindisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h1-pro"
    version   = "latest"
  }

  tags = {
    environment = "win10"
  }

}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                  = var.linux_virtual_machine_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "tomasz"
  admin_password                  = "C1sco123"
  disable_password_authentication = false

  admin_ssh_key {
    username   = "tomasz"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  tags = {
    environment = "production"
  }
}


resource "azurerm_linux_virtual_machine" "fmcv" {
  name                  = var.fmc_virtual_machine_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic-fmc.id]
  size                  = "Standard_D4_v2"

  os_disk {
    name                 = "myFMCDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name      = "fmcv-azure-byol"
    product   = "cisco-fmcv"
    publisher = "cisco"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-fmcv"
    sku       = "fmcv-azure-byol"
    version   = var.fmc_version
  }

  computer_name                   = "fmcv-01"
  admin_username                  = "tomasz"
  admin_password                  = "123Cisco@123!"
  disable_password_authentication = false
  custom_data = base64encode(data.template_file.startup_file_fmc.rendered)

  admin_ssh_key {
    username   = "tomasz"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  tags = {
    environment = "production"
  }
}
