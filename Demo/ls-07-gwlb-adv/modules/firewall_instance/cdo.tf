# terraform {
#   required_providers {
#     cdo = {
#       source = "hashicorp.com/CiscoDevnet/cdo"
#     }
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.75.0"
#     }
#   }
# }

provider "cdo" {
  base_url = "https://apj.cdo.cisco.com"
  api_token = var.cdo_token
}
resource "cdo_ftd_device" "test" {
  count              = 2
  name               = "FTD${count.index+1}"
  access_policy_name = "Default Access Control Policy"
  performance_tier   = "FTDv5"
  virtual            = true
  licenses           = ["BASE"]
}

resource "cdo_ftd_device_onboarding" "test" {
  count = 2
  ftd_uid = cdo_ftd_device.test[count.index].id
}