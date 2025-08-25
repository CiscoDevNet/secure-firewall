locals {
  vpcs = [ module.spoke_network.vpc_id, module.spoke_network_2.vpc_id, module.spoke_network_3.vpc_id ]
  subnet_cidrs = ["10.1.2.0/24","10.2.3.0/24","172.17.2.0/24"]
  # igws= [ module.spoke_network.internet_gateway[0], module.spoke_network_2.internet_gateway[0], module.spoke_network_3.internet_gateway[0]]
}