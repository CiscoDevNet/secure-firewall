####################################################################################
### environment providers
####################################################################################


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.53.0"
    }
  }
}


provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  # subscription_id = "${var.subscription_id}"
  # tenant_id       = "${var.tenant_id}"
  # client_id       = "${var.client_id}"
  # client_secret   = "${var.client_secret}"
  features {}
}

  