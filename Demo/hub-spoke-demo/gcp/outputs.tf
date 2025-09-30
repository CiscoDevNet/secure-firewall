# Inside VPC Outputs (Main Security Hub)
output "inside_vpc_id" {
  description = "ID of the Inside VPC (Security Hub)"
  value       = google_compute_network.inside_vpc.id
}

output "inside_vpc_name" {
  description = "Name of the Inside VPC (Security Hub)"
  value       = google_compute_network.inside_vpc.name
}

# FTDv Firewall Outputs
output "ftdv_egress_management_ip" {
  description = "Management IP of Egress FTDv"
  value       = google_compute_instance.ftdv_egress.network_interface[2].network_ip
}

output "ftdv_egress_outside_public_ip" {
  description = "Outside Public IP of Egress FTDv"
  value       = google_compute_instance.ftdv_egress.network_interface[0].access_config[0].nat_ip
}

output "ftdv_ingress_management_ip" {
  description = "Management IP of Ingress FTDv"
  value       = google_compute_instance.ftdv_ingress.network_interface[2].network_ip
}

output "ftdv_ingress_outside_public_ip" {
  description = "Outside Public IP of Ingress FTDv"
  value       = google_compute_instance.ftdv_ingress.network_interface[0].access_config[0].nat_ip
}

output "ftdv_eastwest_management_ip" {
  description = "Management IP of East-West FTDv"
  value       = google_compute_instance.ftdv_eastwest.network_interface[2].network_ip
}

output "ftdv_eastwest_outside_public_ip" {
  description = "Outside Public IP of East-West FTDv"
  value       = google_compute_instance.ftdv_eastwest.network_interface[0].access_config[0].nat_ip
}

# Spoke VPC Outputs
output "spoke1_vpc_id" {
  description = "ID of Spoke1 VPC"
  value       = google_compute_network.spoke1_vpc.id
}

output "spoke2_vpc_id" {
  description = "ID of Spoke2 VPC"
  value       = google_compute_network.spoke2_vpc.id
}

# VM Outputs
output "spoke1_vm_private_ip" {
  description = "Private IP of Spoke1 VM"
  value       = google_compute_instance.spoke1_vm.network_interface[0].network_ip
}

output "spoke2_vm_private_ip" {
  description = "Private IP of Spoke2 VM"
  value       = google_compute_instance.spoke2_vm.network_interface[0].network_ip
}

# Bastion VPC Outputs
output "bastion_vpc_id" {
  description = "ID of the Bastion VPC"
  value       = google_compute_network.bastion_vpc.id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}

output "bastion_private_ip" {
  description = "Private IP of the bastion host"
  value       = google_compute_instance.bastion.network_interface[0].network_ip
}


output "inside_spoke2_peering_state" {
  description = "State of Inside to Spoke2 VPC peering"
  value       = google_compute_network_peering.inside_to_spoke2.state
}

# Bastion Peering Status Outputs
output "bastion_spoke1_peering_state" {
  description = "State of Bastion to Spoke1 VPC peering"
  value       = google_compute_network_peering.bastion_to_spoke1.state
}

output "bastion_spoke2_peering_state" {
  description = "State of Bastion to Spoke2 VPC peering"
  value       = google_compute_network_peering.bastion_to_spoke2.state
}

# SSH Access Information
output "ssh_access_note" {
  description = "SSH access information"
  value = "To access VMs, use the bastion host or VPN. Spoke VMs have no direct internet access."
}

# SSH Key Outputs
output "ssh_private_key_file" {
  description = "Path to the SSH private key file"
  value       = local_file.private_key.filename
}

output "ssh_public_key" {
  description = "SSH public key for FTDv instances"
  value       = tls_private_key.key_pair.public_key_openssh
}

output "ssh_connection_info" {
  description = "SSH connection information for all instances"
  value = <<-EOT
    SSH Connection Information:
    
    Private Key File: ${local_file.private_key.filename}
    
    FTDv SSH Access (via Management Interface):
    - Egress Firewall:   ssh -i ${local_file.private_key.filename} ${var.ftdv_admin_username}@${google_compute_instance.ftdv_egress.network_interface[2].access_config[0].nat_ip}
    - Ingress Firewall:  ssh -i ${local_file.private_key.filename} ${var.ftdv_admin_username}@${google_compute_instance.ftdv_ingress.network_interface[2].access_config[0].nat_ip}
    - EastWest Firewall: ssh -i ${local_file.private_key.filename} ${var.ftdv_admin_username}@${google_compute_instance.ftdv_eastwest.network_interface[2].access_config[0].nat_ip}
    
    Bastion Host Access (Dedicated Bastion VPC):
    - Direct SSH: ssh -i ${local_file.private_key.filename} admin@${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip}
    - Or with password: ssh admin@${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip} (password: Cisco@123)
    
    Private VM Access (via bastion jump host):
    - Spoke1 VM: ssh -i ${local_file.private_key.filename} -J admin@${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip} admin@${google_compute_instance.spoke1_vm.network_interface[0].network_ip}
    - Spoke2 VM: ssh -i ${local_file.private_key.filename} -J admin@${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip} admin@${google_compute_instance.spoke2_vm.network_interface[0].network_ip}
    
    Alternative (two-step access):
    1. SSH to bastion: ssh -i ${local_file.private_key.filename} admin@${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip}
    2. From bastion SSH to VMs: ssh admin@172.0.0.10 (spoke1) or ssh admin@192.0.0.10 (spoke2)
    
    Note: Make sure to set appropriate file permissions: chmod 600 ${local_file.private_key.filename}
  EOT
}

# Architecture Summary
output "architecture_summary" {
  description = "Summary of the deployed architecture"
  value = <<-EOT
    GCP Multi-Tier Security Architecture Deployed:
    
    Security VPC (10.0.0.0/16):
    - Management Subnet: 10.0.0.0/24
    - Diagnostic Subnet: 10.0.1.0/24
    - Outside Subnet: 10.0.2.0/24
    - Inside Subnet: 10.0.3.0/24
    
    FTDv Firewalls:
    - Egress: 10.0.0.10 (management)
    - Ingress: 10.0.0.20 (management)
    - East-West: 10.0.0.30 (management)
    
    Spoke1 VPC (172.0.0.0/16):
    - Private Subnet: 172.0.0.0/24
    - Ubuntu VM (no internet access)
    
    Spoke2 VPC (192.0.0.0/16):
    - Private Subnet: 192.0.0.0/24
    - Debian VM (no internet access)
    
    Bastion VPC (10.100.0.0/16):
    - Public Subnet: 10.100.0.0/24
    - Bastion Host (public IP for secure access)
    
    VPC Peering:
    - Security ↔ Spoke1
    - Security ↔ Spoke2
    - Bastion ↔ Spoke1
    - Bastion ↔ Spoke2
    - No direct Spoke1 ↔ Spoke2 (traffic via East-West firewall)
  EOT
}