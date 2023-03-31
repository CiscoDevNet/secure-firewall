################################################################################################################################
# Output
################################################################################################################################


output "vm_id" {
  value = azurerm_linux_virtual_machine.linuxvm.id
}

data "azurerm_public_ip" "public_ip_ubuntu1" {
  name                = azurerm_public_ip.public_ip_ubuntu1.name
  resource_group_name = azurerm_linux_virtual_machine.linuxvm.resource_group_name
}
output "public_ip_address_Ubuntu" {
  value = data.azurerm_public_ip.public_ip_ubuntu1.ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

output "fmc_id" {
  value = azurerm_linux_virtual_machine.fmcv.id
}

data "azurerm_public_ip" "public_ip_fmc1" {
  name                = azurerm_public_ip.public_ip_fmc1.name
  resource_group_name = azurerm_linux_virtual_machine.fmcv.resource_group_name
}
output "public_ip_address_fmcv" {
  value = data.azurerm_public_ip.public_ip_fmc1.ip_address
}

output "win_id" {
  value = azurerm_windows_virtual_machine.win10.id
}

data "azurerm_public_ip" "public_ip_win1" {
  name                = azurerm_public_ip.public_ip_win1.name
  resource_group_name = azurerm_windows_virtual_machine.win10.resource_group_name
}
output "public_ip_address_win10" {
  value = data.azurerm_public_ip.public_ip_win1.ip_address
}
