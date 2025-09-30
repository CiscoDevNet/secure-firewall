terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
    sccfm = {
      source  = "CiscoDevnet/sccfm"
      version = "0.2.5"
    }
    fmc = {
      source  = "CiscoDevNet/fmc"
      version = "2.0.0-rc6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}
provider "sccfm" {
  api_token = var.scc_token
  base_url  = var.scc_host
}

# FMC Provider configuration for Cisco Secure Firewall Management Center
provider "fmc" {
  url   = "https://${var.cdfmc_host}"
  token = var.scc_token
}
