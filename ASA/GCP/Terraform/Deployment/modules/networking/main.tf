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
  # enable routing if desired
  #ILB as next hop : https://cloud.google.com/load-balancing/docs/internal/ilb-next-hop-overview#ilb-nh-multi-nic
  #routes = [
  #  {
  #    name              = "${each.value.name}-egress-default"
  #    description       = "${each.value.name} egress route"
  #    destination_range = "0.0.0.0/0"
  #    tags              = var.custom_route_tag
  #    next_hop_ip       = each.value.appliance_ip[0]
  #    priority          = 100
  # }
  #]
}
