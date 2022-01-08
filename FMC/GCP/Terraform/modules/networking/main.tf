###############
# VPC networks
###############
module "vpc-module" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = var.project_id
  network_name = var.network
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "${var.network}-subnet-01"
      subnet_ip             = var.network_subnet_cidr_range
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
  ]
  # enable routing if desired
  #ILB as next hop : https://cloud.google.com/load-balancing/docs/internal/ilb-next-hop-overview#ilb-nh-multi-nic
  # routes = [
  #   {
  #     name              = "fmc-mgmt-route"
  #     description       = "fmc management route"
  #     destination_range = "0.0.0.0/0"
  #     tags              = var.custom_route_tag
  #     next_hop_ip       = var.appliance_ips[0]
  #     priority          = 100
  #   }
  # ]
}
