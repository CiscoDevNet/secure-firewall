# Change according to provided information
devnet_pod = ""

#OOB management
cisco_product_version = "cisco-ftdv-7-3-0-69"
project_id            = "gcp-netsecgcptenant-nprd-79235"
region                = "us-west1"
sa_email              = "devnet-terraform@gcp-netsecgcptenant-nprd-79235.iam.gserviceaccount.com"
vm_zones              = ["us-west1-a"]
vm_machine_type       = "c2-standard-4"
vm_instance_labels = {
  firewall    = "ftd"
}
ftd_hostname          = ""
day_0_config_ftd      = "startup_file.txt"
admin_ssh_pub_key = ""
admin_password    = ""
num_instances     = 1
# This is for 7.2 and later
networks = [
   {
    name         = "devnet-pod01-vpc-outside"
    cidr         = "10.10.12.0/24"
    appliance_ip = ["10.10.12.XX"]
    external_ip  = true
  },
  {
    name         = "devnet-pod01-vpc-inside"
    cidr         = "10.10.13.0/24"
    appliance_ip = ["10.10.13.XX"]
    external_ip  = false
  },
  {
    name         = "devnet-pod01-vpc-mgmt"
    cidr         = "10.10.10.0/24"
    appliance_ip = ["10.10.10.XX"]
    external_ip  = true
  },
  {
    name         = "devnet-pod01-vpc-diag"
    cidr         = "10.10.11.0/24"
    appliance_ip = ["10.10.11.XX"]
    external_ip  = false
  },

  {
    name         = "devnet-pod01-vpc-dmz"
    cidr         = "10.10.14.0/24"
    appliance_ip = ["10.10.14.XX"]
    external_ip  = false
  }
]

mgmt_network    = "devnet-podXX-vpc-mgmt"
inside_network  = "devnet-podXX-vpc-inside"
outside_network = "devnet-podXX-vpc-outside"
dmz_network     = "devnet-podXX-vpc-dmz"
diag_network    = "devnet-podXX-vpc-diag"
appliance_ips_fmc = ["10.10.10.XX"]