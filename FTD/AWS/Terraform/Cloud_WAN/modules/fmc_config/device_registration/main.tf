terraform {
  required_providers {
    fmc = {
      source  = "CiscoDevNet/fmc"
      version = "<= 1.5.2"
    }
  }
}

provider "fmc" {
  fmc_username             = var.fmc_username
  fmc_password             = var.fmc_password
  fmc_host                 = var.fmc_mgmt_ip
  fmc_insecure_skip_verify = var.fmc_insecure_skip_verify
}

locals {
  instance_names = [for i in range(var.inscount) : "FTD-${i + 1}"]
  indices        = [for i in range(var.inscount) : "FTD${i}"]
}

resource "fmc_devices" "ftd_registration" {
  for_each         = toset(local.indices)
  name             = var.instance_names[tonumber(trimprefix(each.key, "FTD"))]
  hostname         = var.ftd_mgmt_ips[tonumber(trimprefix(each.key, "FTD"))]
  regkey           = var.reg_key
  nat_id           = var.fmc_nat_id
  license_caps     = ["MALWARE"]
  performance_tier = var.performance_tier
  access_policy {
    id   = var.access_policy_id
    type = var.access_policy_type
  }
}