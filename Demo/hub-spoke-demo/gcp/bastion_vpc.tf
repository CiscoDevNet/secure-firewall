################################################################################
# BASTION VPC - Dedicated VPC for secure jump host access
################################################################################

# Bastion VPC
resource "google_compute_network" "bastion_vpc" {
  name                    = "${var.resource_prefix}-bastion-vpc"
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"
  description            = "Bastion VPC for secure jump host access to spoke VPCs"
}

# Bastion Public Subnet
resource "google_compute_subnetwork" "bastion_public" {
  name          = "${var.resource_prefix}-bastion-public-subnet"
  ip_cidr_range = "10.100.0.0/24"
  region        = var.region
  network       = google_compute_network.bastion_vpc.id
  description   = "Public subnet for bastion host"
}

################################################################################
# FIREWALL RULES
################################################################################

# Firewall Rules for Bastion VPC
resource "google_compute_firewall" "bastion_ingress" {
  name    = "${var.resource_prefix}-bastion-ingress"
  network = google_compute_network.bastion_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "172.0.0.0/8",
    "192.0.0.0/8",
    "10.0.0.0/8",
    "151.0.0.0/8"
  ]

  target_tags = ["bastion"]
  description = "Allow management traffic to bastion host"
}

resource "google_compute_firewall" "bastion_egress" {
  name    = "${var.resource_prefix}-bastion-egress"
  network = google_compute_network.bastion_vpc.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["bastion"]
  description        = "Allow all outbound traffic from bastion"
}

################################################################################
# ROUTING
################################################################################

# Default route to internet for bastion VPC
resource "google_compute_route" "bastion_default" {
  name         = "${var.resource_prefix}-bastion-default-route"
  dest_range   = "0.0.0.0/0"
  network      = google_compute_network.bastion_vpc.name
  next_hop_gateway = "default-internet-gateway"
  priority     = 1000
  description  = "Default internet route for bastion VPC"
  tags         = ["bastion"]
}

################################################################################
# VPC PEERING - Connect Bastion VPC to Spoke VPCs
################################################################################





################################################################################
# VPC PEERING - Connect Bastion VPC to Spoke VPCs
################################################################################

# Bastion to Spoke1 VPC Peering
resource "google_compute_network_peering" "bastion_to_spoke1" {
  name         = "${var.resource_prefix}-bastion-to-spoke1-peering"
  network      = google_compute_network.bastion_vpc.self_link
  peer_network = google_compute_network.spoke1_vpc.self_link
  
  # import_custom_routes = true
  # export_custom_routes = true
}

# Spoke1 to Bastion VPC Peering
resource "google_compute_network_peering" "spoke1_to_bastion" {
  name         = "${var.resource_prefix}-spoke1-to-bastion-peering"
  network      = google_compute_network.spoke1_vpc.self_link
  peer_network = google_compute_network.bastion_vpc.self_link
  
  # import_custom_routes = true
  # export_custom_routes = true
}

# Bastion to Spoke2 VPC Peering
resource "google_compute_network_peering" "bastion_to_spoke2" {
  name         = "${var.resource_prefix}-bastion-to-spoke2-peering"
  network      = google_compute_network.bastion_vpc.self_link
  peer_network = google_compute_network.spoke2_vpc.self_link
  
  # import_custom_routes = true
  # export_custom_routes = true
}

# Spoke2 to Bastion VPC Peering
resource "google_compute_network_peering" "spoke2_to_bastion" {
  name         = "${var.resource_prefix}-spoke2-to-bastion-peering"
  network      = google_compute_network.spoke2_vpc.self_link
  peer_network = google_compute_network.bastion_vpc.self_link
  
  # import_custom_routes = true
  # export_custom_routes = true
}

################################################################################
# BASTION HOST
################################################################################

# Bastion Host VM
resource "google_compute_instance" "bastion" {
  name         = "${var.resource_prefix}-bastion"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.bastion_vpc.name
    subnetwork = google_compute_subnetwork.bastion_public.name
    access_config {
      # Ephemeral public IP for internet access
    }
  }

  metadata = {
    ssh-keys = "${var.vm_admin_username}:${tls_private_key.key_pair.public_key_openssh}"
    serial-port-enable = "1"
    startup-script = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y net-tools curl wget tcpdump nmap vim htop iotop traceroute

    # Enable password authentication for SSH
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    
    # Create admin user and set password
    sudo useradd -m -s /bin/bash admin
    echo "admin:Cisco@123" | sudo chpasswd
    sudo usermod -aG sudo admin
    
    # Also set password for default debian user
    echo "debian:Cisco@123" | sudo chpasswd
    
    # Add admin to sudoers without password
    echo "admin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/admin
    
    sudo systemctl restart sshd

    # Install additional network tools
    apt-get install -y dnsutils iputils-ping mtr-tiny netcat-openbsd

    # Create a welcome message
    echo "Welcome to the Bastion Host!" | sudo tee /etc/motd
    echo "Use this host to access spoke VMs:" | sudo tee -a /etc/motd
    echo "- Spoke1 VM: ssh admin@172.0.0.10" | sudo tee -a /etc/motd  
    echo "- Spoke2 VM: ssh admin@192.0.0.10" | sudo tee -a /etc/motd
    EOF
    )
  }

  tags = ["bastion"]

  labels = merge(var.common_labels, {
    purpose = "bastion-jumphost"
    tier    = "dmz"
  })

  description = "Bastion host for secure access to spoke VPCs"
}