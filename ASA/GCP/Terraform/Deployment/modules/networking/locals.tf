###############
# Locals
###############
locals {

  # enable_outside_network checks if outside network is defined
  enable_outside_network = var.outside_network != "" ? true : false
  # map for networks, key is the network.name such as "vpc-mgmt", "vpc-inside"
  # used for module/vpc-module for_each so that we can create VPC networks. 
  networks = { for x in var.networks : "${x.name}" => x }

  # map for networks: consudmed by module/load-balancer.
  networks_map = { for x in var.networks :
    "${x.name}" => {
      name              = x.name
      appliance_ip      = x.appliance_ip
      external_ip       = x.external_ip
      network_self_link = module.vpc-module[x.name].network_self_link
      subnet_self_link  = module.vpc-module[x.name].subnets_self_links[0]
      subnet_cidr       = module.vpc-module[x.name].subnets_ips[0]
      routes            = module.vpc-module[x.name].route_names
    }
  }

  # list of neworks: consumed by module/vm.
  networks_list = [for x in var.networks : {
    name              = x.name
    appliance_ip      = x.appliance_ip
    external_ip       = x.external_ip
    network_self_link = module.vpc-module[x.name].network_self_link
    subnet_self_link  = module.vpc-module[x.name].subnets_self_links[0]
    subnet_cidr       = module.vpc-module[x.name].subnets_ips[0]
    routes            = module.vpc-module[x.name].route_names
    }
  ]
}