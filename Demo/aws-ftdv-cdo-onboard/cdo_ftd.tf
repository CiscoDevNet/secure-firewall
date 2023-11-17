terraform {
  required_providers {
    cdo = {
      source  = "CiscoDevNet/cdo"
      version = "0.14.0"
    }
  }
}

provider "cdo" {
  base_url  = "https://apj.cdo.cisco.com"
  api_token = file("${path.module}/api_token.txt")
}

resource "cdo_ftd_device" "ftd" {
  name               = "${var.prefix}-aws-ftd"
  access_policy_name = "Default Access Control Policy"
  performance_tier   = "FTDv10"
  virtual            = true
  licenses           = ["BASE", "THREAT", "MALWARE"]
}

resource "cdo_ftd_device_onboarding" "ftd_onboard" {
  ftd_uid = cdo_ftd_device.ftd.id
}

output "cdo_ftd" {
  value = "${var.prefix}-aws-ftd"
}
