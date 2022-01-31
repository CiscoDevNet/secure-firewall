module "network" {
  source                = "../"
  region                = "us-east-1"
  vpc_cidr              = "10.0.0.0/16"
  inside01_subnet_cidr  = "10.0.4.0/24"
  inside02_subnet_cidr  = "10.0.40.0/24"
  outside02_subnet_cidr = "10.0.50.0/24"
  outside01_subnet_cidr = "10.0.5.0/24"
  dmz01_subnet_cidr     = "10.0.3.0/24"
  dmz02_subnet_cidr     = "10.0.30.0/24"
  mgmt01_subnet_cidr    = "10.0.1.0/24"
  mgmt02_subnet_cidr    = "10.0.10.0/24"
  asa01_mgmt_ip         = "10.0.1.10"
  asa02_mgmt_ip         = "10.0.10.20"
  asa01_outside_ip      = "10.0.5.10"
  asa02_outside_ip      = "10.0.50.20"
  asa01_dmz_ip          = "10.0.3.10"
  asa02_dmz_ip          = "10.0.30.20"
  asa01_inside_ip       = "10.0.4.10"
  asa02_inside_ip       = "10.0.40.20"
}


module "instance" {
  source                = "../../FirewallServer/"
  region                = "us-east-1"
  keyname               = "sophie"
  asa_mgmt_interface    = [module.network.mgmt01_interface, module.network.mgmt02_interface, ]
  asa_outside_interface = [module.network.outside01_interface, module.network.outside02_interface]
  asa_inside_interface  = [module.network.inside01_interface, module.network.inside02_interface]
  asa_dmz_interface     = [module.network.dmz01_interface, module.network.dmz02_interface]
}

module "load_balancer" {
  source              = "../../LoadBalancer/"
  region              = "us-east-1"
  vpc_id              = module.network.vpc_id
  asa01_inside_ip     = module.network.inside01_interface_ip[0]
  asa02_inside_ip     = module.network.inside02_interface_ip[0]
  asa01_outside_ip    = module.network.outside01_interface_ip[0]
  asa02_outside_ip    = module.network.outside02_interface_ip[0]
  outside01_subnet_id = module.network.outside01_subnet
  outside02_subnet_id = module.network.outside02_subnet
  inside01_subnet_id  = module.network.inside01_subnet
  inside02_subnet_id  = module.network.inside02_subnet
}