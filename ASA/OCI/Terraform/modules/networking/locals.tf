###############
# Locals
###############
locals {
  # map for networks, key is the network.name such as "vpc-mgmt", "vpc-inside"
  # used for module/vcn-module for_each so that we can create VCN networks. 
  networks = { for x in var.networks : "${x.name}" => x }

  # map for networks: consumed by module/load-balancer.
  networks_map = { for x in var.networks :
    "${x.name}" => {
      name        = x.name
      private_ip  = x.private_ip
      external_ip = x.external_ip
      vcn_id      = module.vcn-module[x.name].vcn_id
      subnet_id   = oci_core_subnet.vcn-subnet[x.name].id
      subnet_cidr = oci_core_subnet.vcn-subnet[x.name].cidr_block
    }
  }

  # list of neworks: consumed by module/vm.
  networks_list = [for x in var.networks : {
    name        = x.name
    private_ip  = x.private_ip
    external_ip = x.external_ip
    vcn_id      = module.vcn-module[x.name].vcn_id
    subnet_id   = oci_core_subnet.vcn-subnet[x.name].id
    subnet_cidr = oci_core_subnet.vcn-subnet[x.name].cidr_block
    }
  ]
}