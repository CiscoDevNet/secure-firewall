# GCP Project Configuration
project_id = ""
region     = "us-central1"
zone       = "us-central1-a"

# Resource Naming
resource_prefix = "C15C0-gcp"

# Network CIDR Blocks
security_vpc_cidr = "10.0.0.0/16"
spoke1_vpc_cidr   = "172.0.0.0/16"
spoke2_vpc_cidr   = "192.0.0.0/16"

# Security VPC Subnets
management_subnet_cidr = "10.0.0.0/24"
diagnostic_subnet_cidr = "10.0.1.0/24"
outside_subnet_cidr    = "10.0.2.0/24"
inside_subnet_cidr     = "10.0.3.0/24"

# Spoke Subnet CIDR Blocks
spoke1_private_subnet_cidr = "172.0.0.0/24"
spoke2_private_subnet_cidr = "192.0.0.0/24"

# FTDv Configuration
ftdv_machine_type       = "c2-standard-8"
ftdv_admin_password     = "Cisco@123"
cisco_product_version   = "cisco-ftdv-7-7-0-89"

# FTDv IP Addresses - Egress Firewall
ftdv_egress_management_ip = "10.0.0.10"
ftdv_egress_diagnostic_ip = "10.0.1.10"
ftdv_egress_outside_ip    = "10.0.2.10"
ftdv_egress_inside_ip     = "10.0.3.10"

# FTDv IP Addresses - Ingress Firewall
ftdv_ingress_management_ip = "10.0.0.20"
ftdv_ingress_diagnostic_ip = "10.0.1.20"
ftdv_ingress_outside_ip    = "10.0.2.20"
ftdv_ingress_inside_ip     = "10.0.3.20"

# FTDv IP Addresses - East-West Firewall
ftdv_eastwest_management_ip = "10.0.0.30"
ftdv_eastwest_diagnostic_ip = "10.0.1.30"
ftdv_eastwest_outside_ip    = "10.0.2.30"
ftdv_eastwest_inside_ip     = "10.0.3.30"

# VM Configuration
vm_machine_type    = "e2-medium"
vm_admin_username  = "admin"

# FTDv Admin Configuration
ftdv_admin_username = "admin"

# Common Labels
common_labels = {
  environment = "production"
  project     = "C15C0-security-architecture"
  managed-by  = "terraform"
  team        = "security"
}

# SCCFM and FMC Configuration