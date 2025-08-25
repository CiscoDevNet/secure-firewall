terraform {
  required_providers {
    fmc = {
      source = "CiscoDevNet/fmc"
    }
  }
}

provider "fmc" {
  fmc_username = "admin"
  fmc_password = var.fmc_admin_password
  fmc_host = var.fmc_ip
  fmc_insecure_skip_verify = var.fmc_insecure_skip_verify
}