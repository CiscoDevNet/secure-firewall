module "service_network" {
  source                  = "../modules/network"
  prefix                  = var.prefix
  vpc_cidr                = var.service_vpc_cidr
  vpc_name                = var.service_vpc_name
  outside_interface_sg    = var.outside_interface_sg
  inside_interface_sg     = var.inside_interface_sg
  mgmt_interface_sg       = var.mgmt_interface_sg
  use_ftd_eip             = var.use_ftd_eip
  create_igw              = true
  ftd_count               = var.availability_zone_count * var.instances_per_az
  availability_zone_count = var.availability_zone_count
}

module "instance" {
  source                  = "../modules/firewall_instance"
  prefix                  = var.prefix
  ftd_version             = var.ftd_version
  byol                    = var.byol
  keyname                 = var.keyname
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  ftd_mgmt_interface      = module.service_network.mgmt_interface
  ftd_inside_interface    = module.service_network.inside_interface
  ftd_outside_interface   = module.service_network.outside_interface
  ftd_diag_interface      = module.service_network.diag_interface
  fmc_mgmt_ip             = var.fmc_mgmt_ip
  reg_key                 = var.reg_key
  fmc_nat_id              = var.fmc_nat_id
  ftd_admin_password      = var.ftd_admin_password
}

module "gwlb" {
  source      = "../modules/gwlb"
  prefix      = var.prefix
  gwlb_name   = var.gwlb_name
  gwlb_subnet = module.service_network.inside_subnet
  gwlb_vpc_id = module.service_network.vpc_id
  instance_ip = module.service_network.inside_interface_ip

}

module "gwlbe" {
  source                  = "../modules/gwlbe"
  prefix                  = var.prefix
  availability_zone_count = var.availability_zone_count
  vpc_id                  = module.service_network.vpc_id
  service_vpc_cidr        = var.service_vpc_cidr
  gwlb                    = module.gwlb.gwlb
  internet_gateway        = module.service_network.internet_gateway
}

module "external_load_balancer" {
  source            = "../modules/load_balancer"
  prefix            = var.prefix
  create            = "external"
  vpc_id            = module.service_network.vpc_id
  inside_subnet_id  = module.service_network.inside_subnet
  outside_subnet_id = module.service_network.outside_subnet
  ftd_inside_ip     = module.service_network.inside_interface_ip
  ftd_outside_ip    = module.service_network.outside_interface_ip
}

module "cloud_wan_attachment" {
  source                      = "../modules/cloudwan"
  prefix                      = var.prefix
  vpc_service_id              = module.service_network.vpc_id
  service_vpc_cidr            = var.service_vpc_cidr
  wan_subnet_cidr             = var.wan_subnet_cidr
  wan_subnet_name             = var.wan_subnet_name
  gwlbe                       = module.gwlbe.gwlb_endpoint_id
  availability_zone_count     = var.availability_zone_count
  gwlbe_subnet_routetable_ids = module.gwlbe.gwlbe_rt_id
}

resource "local_file" "FTD_Mgmt_Public_IPs" {
  filename = "${path.module}/FTD_Mgmt_Public_IPs.txt"
  content  = join(",", module.service_network.aws_ftd_eip)
}

##############################################################################
## Comment this section to SKIP the FMC Configuration                       ##
##############################################################################
resource "time_sleep" "wait_for_ftd_initialization" {
  depends_on = [module.service_network, module.instance, module.gwlb, module.gwlbe, module.external_load_balancer, module.cloud_wan_attachment, local_file.FTD_Mgmt_Public_IPs]

  create_duration = "15m"
}

module "fmc_configuration" {
  depends_on               = [time_sleep.wait_for_ftd_initialization]
  source                   = "../modules/fmc_config"
  fmc_mgmt_ip              = var.fmc_mgmt_ip
  fmc_username             = var.fmc_username
  fmc_password             = var.fmc_password
  fmc_insecure_skip_verify = var.fmc_insecure_skip_verify
  reg_key                  = var.reg_key
  fmc_nat_id               = var.fmc_nat_id
  inscount                 = length(module.service_network.aws_ftd_eip)
  ftd_mgmt_ips             = module.service_network.aws_ftd_eip
  ftd_inside_ips           = module.service_network.inside_interface_ip
  ftd_outside_ips          = module.service_network.outside_interface_ip
  performance_tier         = var.performance_tier
  ftd_version              = var.ftd_version
}
##############################################################################
##############################################################################