# Spoke1 VPC
resource "google_compute_network" "spoke1_vpc" {
  name                    = "${var.resource_prefix}-spoke1-vpc"
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"
  description            = "Spoke1 VPC for workload isolation"
}

# Spoke1 Private Subnet
resource "google_compute_subnetwork" "spoke1_private" {
  name          = "${var.resource_prefix}-spoke1-private-subnet"
  ip_cidr_range = var.spoke1_private_subnet_cidr
  region        = var.region
  network       = google_compute_network.spoke1_vpc.id
  description   = "Private subnet for Spoke1 workloads"
}

# Spoke2 VPC
resource "google_compute_network" "spoke2_vpc" {
  name                    = "${var.resource_prefix}-spoke2-vpc"
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"
  description            = "Spoke2 VPC for workload isolation"
}

# Spoke2 Private Subnet
resource "google_compute_subnetwork" "spoke2_private" {
  name          = "${var.resource_prefix}-spoke2-private-subnet"
  ip_cidr_range = var.spoke2_private_subnet_cidr
  region        = var.region
  network       = google_compute_network.spoke2_vpc.id
  description   = "Private subnet for Spoke2 workloads"
}

# Firewall Rules for Spoke1
resource "google_compute_firewall" "spoke1_ingress" {
  name    = "${var.resource_prefix}-spoke1-ingress"
  network = google_compute_network.spoke1_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = [
    "172.0.0.0/8",
    "192.0.0.0/8",
    "10.0.0.0/8",
    "151.0.0.0/8"
  ]

  target_tags = ["spoke1-vm"]
  description = "Allow traffic from trusted networks to Spoke1"
}

# Allow bastion VPC to access Spoke1 VMs
resource "google_compute_firewall" "spoke1_bastion_access" {
  name    = "${var.resource_prefix}-spoke1-bastion-access"
  network = google_compute_network.spoke1_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.100.0.0/24"]  # Bastion VPC CIDR
  target_tags   = ["spoke1-vm"]
  description   = "Allow bastion VPC access to Spoke1 VMs"
}

resource "google_compute_firewall" "spoke1_egress" {
  name    = "${var.resource_prefix}-spoke1-egress"
  network = google_compute_network.spoke1_vpc.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["spoke1-vm"]
  description        = "Allow all outbound traffic from Spoke1"
}

# Firewall Rules for Spoke2
resource "google_compute_firewall" "spoke2_ingress" {
  name    = "${var.resource_prefix}-spoke2-ingress"
  network = google_compute_network.spoke2_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = [
    "172.0.0.0/8",
    "192.0.0.0/8",
    "10.0.0.0/8",
    "151.0.0.0/8"
  ]

  target_tags = ["spoke2-vm"]
  description = "Allow traffic from trusted networks to Spoke2"
}

# Allow bastion VPC to access Spoke2 VMs
resource "google_compute_firewall" "spoke2_bastion_access" {
  name    = "${var.resource_prefix}-spoke2-bastion-access"
  network = google_compute_network.spoke2_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.100.0.0/24"]  # Bastion VPC CIDR
  target_tags   = ["spoke2-vm"]
  description   = "Allow bastion VPC access to Spoke2 VMs"
}

resource "google_compute_firewall" "spoke2_egress" {
  name    = "${var.resource_prefix}-spoke2-egress"
  network = google_compute_network.spoke2_vpc.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["spoke2-vm"]
  description        = "Allow all outbound traffic from Spoke2"
}

################################################################################
# ROUTING CONFIGURATION
################################################################################
# Traffic Flows:
# 1. Egress Traffic: Spoke1/Spoke2 -> Egress FTDv Inside -> Egress FTDv Outside -> Internet
# 2. East-West Traffic: Spoke1 -> East-West FTDv Inside -> East-West FTDv Outside -> Spoke2
# 3. VPC Peering handles connectivity between Security VPC and Spoke VPCs
################################################################################

################################################################################
# CUSTOM ROUTES - Control traffic flow through FTDv firewalls
################################################################################

# Internet traffic routing for security inspection:
# 1. Spoke VMs send internet traffic (no specific route needed - will use default)
# 2. Traffic flows to inside VPC via VPC peering 
# 3. Inside VPC routes internet traffic through egress FTDv (configured in security_vpc.tf)
# 4. Egress FTDv inspects and forwards to internet via outside interface
#
# Note: Default internet routes in spoke VPCs (priority 1000) will be overridden
# by the inside VPC custom route (priority 800) via VPC peering route advertisement

# The real solution: Remove the problematic route from inside VPC 
# The inside-to-spoke1 route should not exist as it creates routing loops
# East-west traffic should be handled differently

################################################################################
# VPC PEERING - Connect Spoke VPCs to Inside VPC for firewall transit
################################################################################

# Spoke1 to Inside VPC Peering
resource "google_compute_network_peering" "spoke1_to_inside" {
  name         = "${var.resource_prefix}-spoke1-to-inside-peering"
  network      = google_compute_network.spoke1_vpc.self_link
  peer_network = google_compute_network.inside_vpc.self_link
  
  import_custom_routes = true
  export_custom_routes = true
}

# Inside VPC to Spoke1 Peering
resource "google_compute_network_peering" "inside_to_spoke1" {
  name         = "${var.resource_prefix}-inside-to-spoke1-peering"
  network      = google_compute_network.inside_vpc.self_link
  peer_network = google_compute_network.spoke1_vpc.self_link
  
  import_custom_routes = true
  export_custom_routes = true
}

# Spoke2 to Inside VPC Peering
resource "google_compute_network_peering" "spoke2_to_inside" {
  name         = "${var.resource_prefix}-spoke2-to-inside-peering"
  network      = google_compute_network.spoke2_vpc.self_link
  peer_network = google_compute_network.inside_vpc.self_link
  
  import_custom_routes = true
  export_custom_routes = true
}

# Inside VPC to Spoke2 Peering
resource "google_compute_network_peering" "inside_to_spoke2" {
  name         = "${var.resource_prefix}-inside-to-spoke2-peering"
  network      = google_compute_network.inside_vpc.self_link
  peer_network = google_compute_network.spoke2_vpc.self_link
  
  import_custom_routes = true
  export_custom_routes = true
}

################################################################################
# VIRTUAL MACHINES
################################################################################

# Debian VM in Spoke1 (no external IP)
resource "google_compute_instance" "spoke1_vm" {
  name         = "${var.resource_prefix}-spoke1-vm"
  machine_type = var.vm_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.spoke1_vpc.name
    subnetwork = google_compute_subnetwork.spoke1_private.name
    network_ip = "172.16.0.10"  # Static private IP for consistent connectivity
    # No access_config block = no external IP
  }

  metadata = {
    ssh-keys = "${var.vm_admin_username}:${tls_private_key.key_pair.public_key_openssh}"
    serial-port-enable         = "true" 
    startup-script = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y net-tools curl wget tcpdump nmap
    
    # Install nginx for testing
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config  
    echo "ubuntu:Cisco@123" | sudo chpasswd
    sudo systemctl restart sshd

    # Create simple index page with VM info
    echo "<h1>Spoke2 Test VM</h1><p>Private IP: $(hostname -I | cut -d' ' -f1)</p><p>Hostname: $(hostname)</p>" > /var/www/html/index.html
    EOF
  )
  }

  tags = ["spoke1-vm"]

  labels = merge(var.common_labels, {
    purpose = "spoke1-test-vm"
  })

  description = "Ubuntu test VM in Spoke1 private subnet"
}

# Debian VM in Spoke2 (no external IP)
resource "google_compute_instance" "spoke2_vm" {
  name         = "${var.resource_prefix}-spoke2-vm"
  machine_type = var.vm_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.spoke2_vpc.name
    subnetwork = google_compute_subnetwork.spoke2_private.name
    network_ip = "192.168.0.10"  # Static private IP for consistent connectivity
    # No access_config block = no external IP
  }

  metadata = {
    ssh-keys = "${var.vm_admin_username}:${tls_private_key.key_pair.public_key_openssh}"
    serial-port-enable         = "true" 
    startup-script = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y net-tools curl wget tcpdump nmap
    
    # Install nginx for testing
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config  
    echo "ubuntu:Cisco@123" | sudo chpasswd
    sudo systemctl restart sshd

    # Create simple index page with VM info
    echo "<h1>Spoke2 Test VM</h1><p>Private IP: $(hostname -I | cut -d' ' -f1)</p><p>Hostname: $(hostname)</p>" > /var/www/html/index.html
    EOF
  )
  }

  tags = ["spoke2-vm"]

  labels = merge(var.common_labels, {
    purpose = "spoke2-test-vm"
  })

  description = "Ubuntu test VM in Spoke2 private subnet"
}