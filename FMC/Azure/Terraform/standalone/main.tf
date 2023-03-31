# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.65.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  # subscription_id = "..."
  # client_id       = "..."
  # client_secret   = "..."
  # tenant_id       = "..."
}

# Create a resource group
module "fmc-azure" {
  source                           = "../module/fmc-azure"
  virtual_machine_admin_username   = "cisco"
  virtual_machine_admin_passw      = "tqtqtug1452@@"
  virtual_machine_fmcv_admin_passw = "123Cisco@1"
  network_interface_fmc            = "fmcmgmt"
}
