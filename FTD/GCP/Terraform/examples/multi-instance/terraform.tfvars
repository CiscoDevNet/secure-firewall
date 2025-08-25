#OOB management
cisco_product_version = "cisco-ftdv-7-3-0-69"
project_id            = "gcp-netsecgcptenant-nprd-79235"
region                = "us-west1"
vm_zones              = ["us-west1-a","us-west1-a"]
vm_machine_type       = "c2-standard-8"
vm_instance_labels = {
  firewall    = "ftd"
  environment = "dev"
}
ftd_hostname          = "cisco-ftd"
fmc_hostname          = "cisco-fmc"
day_0_config_ftd      = "startup_file.txt"
day_0_config_fmc     = "fmc.txt"
admin_ssh_pub_key    = "<Enter Public Key>"
admin_password       = "<Enter Password>"
num_instances        = 2


# On Secure Firewall version 7.1 and earlier releases, the mapping of Network Interface Cards (NICs) to data interfaces is as follows:

# networks = [
#   {
#     name         = "vpc-mgmt"
#     cidr         = "10.10.0.0/24"
#     appliance_ip = ["10.10.0.10", "10.10.0.11"]
#     external_ip  = true
#   },
#   {
#     name         = "vpc-diag"
#     cidr         = "10.10.1.0/24"
#     appliance_ip = ["10.10.1.10", "10.10.1.11"]
#     external_ip  = false
#   },
#   {
#     name         = "vpc-outside"
#     cidr         = "10.10.2.0/24"
#     appliance_ip = ["10.10.2.10", "10.10.2.11"]
#     external_ip  = true
#   },
#   {
#     name         = "vpc-inside"
#     cidr         = "10.10.3.0/24"
#     appliance_ip = ["10.10.3.10", "10.10.3.11"]
#     external_ip  = false
#   }
# ]


# From Secure Firewall version 7.2, a data interface is required on nic0 to facilitate movement of north-south traffic because the external load balancer (ELB) forwards packets only to nic0.
#The mapping of NICs and data interfaces on Secure Firewall version 7.2 is as given below:
networks = [
  {
    name         = "vpc-outside"
    cidr         = "10.10.0.0/24"
    appliance_ip = ["10.10.0.10", "10.10.0.11"]
    external_ip  = true
  },
  {
    name         = "vpc-inside"
    cidr         = "10.10.1.0/24"
    appliance_ip = ["10.10.1.10", "10.10.1.11"]
    external_ip  =false
  },
  {
    name         = "vpc-mgmt"
    cidr         = "10.10.2.0/24"
    appliance_ip = ["10.10.2.10", "10.10.2.11"]
    external_ip  = true
  },
  {
    name         = "vpc-diag"
    cidr         = "10.10.3.0/24"
    appliance_ip = ["10.10.3.10", "10.10.3.11"]
    external_ip  = false
  }
]

mgmt_network    = "vpc-mgmt"
inside_network  = "vpc-inside"
outside_network = "vpc-outside"
diag_network    = "vpc-diag"


appliance_ips_fmc  = ["10.10.2.20"]
boot_disk_type     = "pd-ssd"
boot_disk_size     = "250"