# Resource Groups for Azure VNet Peering Architecture

# Security VNet Resource Group
resource "azurerm_resource_group" "security" {
  name     = "rg-${var.resource_prefix}-security-${var.common_tags.Environment}"
  location = var.azure_region
  tags = merge(var.common_tags, {
    Purpose = "Security Infrastructure"
  })
}

# Spoke1 Resource Group
resource "azurerm_resource_group" "spoke1" {
  name     = "rg-${var.resource_prefix}-spoke1-${var.common_tags.Environment}"
  location = var.azure_region
  tags = merge(var.common_tags, {
    Purpose = "Spoke1 Workloads"
  })
}

# Spoke2 Resource Group
resource "azurerm_resource_group" "spoke2" {
  name     = "rg-${var.resource_prefix}-spoke2-${var.common_tags.Environment}"
  location = var.azure_region
  tags = merge(var.common_tags, {
    Purpose = "Spoke2 Workloads"
  })
}