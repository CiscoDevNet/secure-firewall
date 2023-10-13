module "service_network" {
  source                = "../modules/network"
  pod_prefix          = var.pod_prefix
  vpc_name             = var.service_vpc_name
  vpc_cidr             = var.service_vpc_cidr
  create_igw           = var.service_create_igw
  igw_name             = var.service_igw_name
  mgmt_subnet_cidr     = var.mgmt_subnet_cidr
  outside_subnet_cidr  = var.outside_subnet_cidr
  diag_subnet_cidr     = var.diag_subnet_cidr
  inside_subnet_cidr   = var.inside_subnet_cidr
  fmc_ip               = var.fmc_ip
  mgmt_subnet_name     = var.mgmt_subnet_name
  outside_subnet_name  = var.outside_subnet_name
  diag_subnet_name     = var.diag_subnet_name
  inside_subnet_name   = var.inside_subnet_name
  outside_interface_sg = var.outside_interface_sg
  inside_interface_sg  = var.inside_interface_sg
  mgmt_interface_sg    = var.mgmt_interface_sg
  use_ftd_eip          = var.use_ftd_eip
  create_fmc              = var.create_fmc
  nat_gw              = module.nat_gw.ngw
}

module "spoke_network" {
  source              = "../modules/network"
  pod_prefix          = var.pod_prefix
  vpc_name            = var.a_vpc_name
  vpc_cidr            = var.a_vpc_cidr
  create_igw          = var.a_create_igw
  igw_name            = var.a_igw_name
  outside_subnet_cidr = var.a_subnet_cidr
  outside_subnet_name = var.a_subnet_name
}
module "spoke_network_2" {
  source              = "../modules/network"
  pod_prefix          = var.pod_prefix
  vpc_name            = var.b_vpc_name
  vpc_cidr            = var.b_vpc_cidr
  create_igw          = var.b_create_igw
  igw_name            = var.b_igw_name
  outside_subnet_cidr = var.b_subnet_cidr
  outside_subnet_name = var.b_subnet_name
}
module "spoke_network_3" {
  source              = "../modules/network"
  pod_prefix          = var.pod_prefix
  vpc_name            = var.c_vpc_name
  vpc_cidr            = var.c_vpc_cidr
  create_igw          = var.c_create_igw
  igw_name            = var.c_igw_name
  outside_subnet_cidr = var.c_subnet_cidr
  outside_subnet_name = var.c_subnet_name
}
module "instance" {
  source                  = "../modules/firewall_instance"
  pod_prefix          = var.pod_prefix
  ftd_version             = var.ftd_version
  keyname                 = aws_key_pair.deployer.key_name
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  fmc_mgmt_ip             = var.fmc_ip
  ftd_mgmt_interface      = module.service_network.mgmt_interface
  ftd_inside_interface    = module.service_network.inside_interface
  ftd_outside_interface   = module.service_network.outside_interface
  ftd_diag_interface      = module.service_network.diag_interface
  create_fmc              = var.create_fmc
  fmcmgmt_interface       = module.service_network.fmcmgmt_interface
  cdo_token               = var.cdo_token
  base_url                = var.cdo_url
}

module "nat_gw" {
  source                  = "../modules/nat_gw"
  pod_prefix          = var.pod_prefix
  ngw_subnet_cidr         = var.ngw_subnet_cidr
  ngw_subnet_name         = var.ngw_subnet_name
  availability_zone_count = var.availability_zone_count
  vpc_id                  = module.service_network.vpc_id
  internet_gateway        = module.service_network.internet_gateway[0]
}

module "gwlb" {
  source      = "../modules/gwlb"
  pod_prefix          = var.pod_prefix
  gwlb_name   = var.gwlb_name
  gwlb_subnet = module.service_network.outside_subnet
  gwlb_vpc_id = module.service_network.vpc_id
  #instance_ip = var.ftd_outside_ip
  instance_ip = module.service_network.outside_interface_ip
}

module "gwlbe" {
  source            = "../modules/gwlbe"
  pod_prefix          = var.pod_prefix
  gwlbe_subnet_cidr = var.gwlbe_subnet_cidr
  gwlbe_subnet_name = var.gwlbe_subnet_name
  vpc_id            = module.service_network.vpc_id
  gwlb              = module.gwlb.gwlb
  spoke_subnet      = module.spoke_network.outside_subnet
  nat_gw              = module.nat_gw.ngw
}

module "transitgateway" {
  source                      = "../modules/transitgateway"
  pod_prefix          = var.pod_prefix
  create_tgw                  = var.create_tgw
  vpc_service_id              = module.service_network.vpc_id
  tgw_subnet_cidr             = var.tgw_subnet_cidr
  tgw_subnet_name             = var.tgw_subnet_name
  
  vpc_spoke_id                = module.spoke_network.vpc_id
  vpc_spoke_cidr              = module.spoke_network.vpc_cidr
  spoke_subnet_id             = module.spoke_network.outside_subnet
  spoke_rt_id                 = module.spoke_network.outside_rt_id
  
  vpc_spoke_id_2                = module.spoke_network_2.vpc_id
  vpc_spoke_cidr_2             = module.spoke_network_2.vpc_cidr
  spoke_subnet_id_2             = module.spoke_network_2.outside_subnet
  spoke_rt_id_2                 = module.spoke_network_2.outside_rt_id

  vpc_spoke_id_3                = module.spoke_network_3.vpc_id
  vpc_spoke_cidr_3              = module.spoke_network_3.vpc_cidr
  spoke_subnet_id_3             = module.spoke_network_3.outside_subnet
  spoke_rt_id_3                = module.spoke_network_3.outside_rt_id

  gwlbe                       = module.gwlbe.gwlb_endpoint_id
  transit_gateway_name        = var.transit_gateway_name
  availability_zone_count     = var.availability_zone_count
  # nat_subnet_routetable_ids   = module.nat_gw.nat_rt_id
  gwlbe_subnet_routetable_ids = module.gwlbe.gwlbe_rt_id
}


############### Used for FMC-Provider

