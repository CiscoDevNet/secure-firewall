  
################################################################################################
### resource outputs
################################################################################################

output "resource_group_name" {
  value       = "${azurerm_resource_group.ftdv.*.name}"
  description = "resource group name"
}
output "location" {
  value       = "${azurerm_resource_group.ftdv.*.location}"
  description = "resource group location"
}

output "resource_group_id" {
  value       = "${azurerm_resource_group.ftdv.*.id}"
  description = "resource group id"
}
