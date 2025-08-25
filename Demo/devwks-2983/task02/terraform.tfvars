# Change according to provided information
devnet_pod = "01"

#OOB management
cisco_product_version = "cisco-ftdv-7-4-1-172"
project_id            = "your_project_id"
region                = "us-west1"
sa_email              = "your_sa_email"
vm_zones              = ["us-west1-a"]
vm_machine_type       = "c2-standard-8"
vm_instance_labels = {
  firewall    = "ftd"
}
ftd_hostname          = "devnet-ftd-pod01"
day_0_config_ftd      = "startup_file.txt"
admin_ssh_pub_key = ""
admin_password    = ""
num_instances     = 1
# This is for FTD version 7.2 and later, it has different interface ordering.
networks = [
   {
    name         = "devnet-pod01-vpc-outside"
    cidr         = "10.10.12.0/24"
    appliance_ip = ["10.10.12.201"]
    external_ip  = true
  },
  {
    name         = "devnet-pod01-vpc-inside"
    cidr         = "10.10.13.0/24"
    appliance_ip = ["10.10.13.201"]
    external_ip  = false
  },
  {
    name         = "devnet-pod01-vpc-mgmt"
    cidr         = "10.10.10.0/24"
    appliance_ip = ["10.10.10.201"]
    external_ip  = true
  },
  {
    name         = "devnet-pod01-vpc-diag"
    cidr         = "10.10.11.0/24"
    appliance_ip = ["10.10.11.201"]
    external_ip  = false
  },
  {
    name         = "devnet-pod01-vpc-dmz"
    cidr         = "10.10.14.0/24"
    appliance_ip = ["10.10.14.201"]
    external_ip  = false
  }
]

mgmt_network    = "devnet-pod01-vpc-mgmt"
inside_network  = "devnet-pod01-vpc-inside"
outside_network = "devnet-pod01-vpc-outside"
dmz_network     = "devnet-pod01-vpc-dmz"
diag_network    = "devnet-pod01-vpc-diag"
appliance_ips_fmc = ["10.10.10.151"]