###############
# VPC networks
###############
module "vpc-module" {
  for_each = local.networks
  source   = "terraform-google-modules/network/google"
  version  = "~> 3.0"

  project_id   = var.project_id
  network_name = each.value.name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "${each.value.name}-subnet-01"
      subnet_ip             = each.value.cidr
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
  ]
}
