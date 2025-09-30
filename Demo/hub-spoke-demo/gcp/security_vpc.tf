data "google_compute_image" "ftd" {
  project = "cisco-public"
  name    = var.cisco_product_version
}

################################################ SSH-KEYS #################################################

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.key_pair.private_key_openssh
  filename        = "cisco-ftdv-key"
  file_permission = "0700"
}

################################################ INFRASTRUCTURE #################################################

# Separate VPCs for FTDv multi-interface configuration (GCP requirement)

# Management VPC - For FTDv management interfaces (Public)
resource "google_compute_network" "management_vpc" {
  name                    = "${var.resource_prefix}-management-vpc"
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"
  description            = "Management VPC for FTDv firewall management interfaces"
}

resource "google_compute_subnetwork" "management" {
  name          = "${var.resource_prefix}-management-subnet"
  ip_cidr_range = var.management_subnet_cidr
  region        = var.region
  network       = google_compute_network.management_vpc.id
  description   = "Management subnet for FTDv firewall management interfaces"
}

# Diagnostic VPC - For FTDv diagnostic interfaces
resource "google_compute_network" "diagnostic_vpc" {
  name                    = "${var.resource_prefix}-diagnostic-vpc"
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"
  description            = "Diagnostic VPC for FTDv firewall diagnostic interfaces"
}

resource "google_compute_subnetwork" "diagnostic" {
  name          = "${var.resource_prefix}-diagnostic-subnet"
  ip_cidr_range = var.diagnostic_subnet_cidr
  region        = var.region
  network       = google_compute_network.diagnostic_vpc.id
  description   = "Diagnostic subnet for FTDv firewall diagnostic interfaces"
}

# Outside VPC - For FTDv outside/untrust interfaces (Public)
resource "google_compute_network" "outside_vpc" {
  name                    = "${var.resource_prefix}-outside-vpc"
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"
  description            = "Outside VPC for FTDv firewall external interfaces"
}

resource "google_compute_subnetwork" "outside" {
  name          = "${var.resource_prefix}-outside-subnet"
  ip_cidr_range = var.outside_subnet_cidr
  region        = var.region
  network       = google_compute_network.outside_vpc.id
  description   = "Outside subnet for FTDv firewall external interfaces"
}

# Inside VPC - For FTDv inside/trust interfaces (Security Hub)
resource "google_compute_network" "inside_vpc" {
  name                    = "${var.resource_prefix}-inside-vpc"
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"
  description            = "Inside VPC for FTDv firewall internal interfaces and spoke connections"
}

resource "google_compute_subnetwork" "inside" {
  name          = "${var.resource_prefix}-inside-subnet"
  ip_cidr_range = var.inside_subnet_cidr
  region        = var.region
  network       = google_compute_network.inside_vpc.id
  description   = "Inside subnet for FTDv firewall internal interfaces"
}

# Firewall Rules for Management VPC
resource "google_compute_firewall" "management_ingress" {
  name    = "${var.resource_prefix}-management-ingress"
  network = google_compute_network.management_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "8305"]
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

  target_tags = ["ftdv-management"]
  description = "Allow management traffic to FTDv management interfaces"
}

resource "google_compute_firewall" "management_egress" {
  name    = "${var.resource_prefix}-management-egress"
  network = google_compute_network.management_vpc.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["ftdv-management"]
  description        = "Allow all outbound traffic from management interfaces"
}

# Firewall Rules for Outside VPC
resource "google_compute_firewall" "outside_ingress" {
  name    = "${var.resource_prefix}-outside-ingress"
  network = google_compute_network.outside_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = [
    "172.0.0.0/8",
    "192.0.0.0/8",
    "10.0.0.0/8", 
    "151.0.0.0/8"
  ]

  target_tags = ["ftdv-outside"]
  description = "Allow traffic from trusted networks to outside interfaces"
}

resource "google_compute_firewall" "outside_egress" {
  name    = "${var.resource_prefix}-outside-egress"
  network = google_compute_network.outside_vpc.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["ftdv-outside"]
  description        = "Allow all outbound traffic from outside interfaces"
}

# Firewall Rules for Inside VPC
resource "google_compute_firewall" "inside_ingress" {
  name    = "${var.resource_prefix}-inside-ingress"
  network = google_compute_network.inside_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = [
    "172.0.0.0/8",
    "192.0.0.0/8",
    "10.0.0.0/8",
    "151.0.0.0/8"
  ]

  target_tags = ["ftdv-inside"]
  description = "Allow traffic from trusted networks to inside interfaces"
}

resource "google_compute_firewall" "inside_egress" {
  name    = "${var.resource_prefix}-inside-egress"
  network = google_compute_network.inside_vpc.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["ftdv-inside"]
  description        = "Allow all outbound traffic from inside interfaces"
}

# Firewall Rules for Diagnostic VPC
resource "google_compute_firewall" "diagnostic_ingress" {
  name    = "${var.resource_prefix}-diagnostic-ingress"
  network = google_compute_network.diagnostic_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = [
    "172.0.0.0/8",
    "192.0.0.0/8",
    "10.0.0.0/8",
    "151.0.0.0/8"
  ]

  target_tags = ["ftdv-diagnostic"]
  description = "Allow traffic from trusted networks to diagnostic interfaces"
}

resource "google_compute_firewall" "diagnostic_egress" {
  name    = "${var.resource_prefix}-diagnostic-egress"
  network = google_compute_network.diagnostic_vpc.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["ftdv-diagnostic"]
  description        = "Allow all outbound traffic from diagnostic interfaces"
}

################################################################################
# ROUTING CONFIGURATION
################################################################################
# Security VPC routing relies on:
# 1. VPC Peering for spoke connectivity (automatic routes)
# 2. Default internet gateway for outside subnet
# 3. FTDv instances handle traffic inspection and forwarding
################################################################################

# Routes for Outside VPC - Default route to internet
resource "google_compute_route" "outside_default" {
  name         = "${var.resource_prefix}-outside-default-route"
  dest_range   = "0.0.0.0/0"
  network      = google_compute_network.outside_vpc.name
  next_hop_gateway = "default-internet-gateway"
  priority     = 1000
  description  = "Default internet route for outside subnet"
  tags         = ["outside-route"]
}

# VPC Peering will automatically handle routing between Security VPC and Spoke VPCs
# No additional routes needed in Security VPC for spoke connectivity

################################################################################
# FTDv Firewall Instances
################################################################################

# Egress FTDv Firewall
resource "google_compute_instance" "ftdv_egress" {
  name              = "${var.resource_prefix}-egress-ftdv"
  machine_type      = var.ftdv_machine_type
  zone              = var.zone
  can_ip_forward    = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ftd.self_link
    }
  }

  # Outside Interface (nic0)
  network_interface {
    subnetwork = google_compute_subnetwork.outside.name
    network_ip = var.ftdv_egress_outside_ip
    access_config {
      # Ephemeral public IP for internet access
    }
  }

  # Inside Interface (nic1)
  network_interface {
    subnetwork = google_compute_subnetwork.inside.name
    network_ip = var.ftdv_egress_inside_ip
  }

  # Management Interface (nic2)
  network_interface {
    subnetwork = google_compute_subnetwork.management.name
    network_ip = var.ftdv_egress_management_ip
    access_config {
      # Ephemeral public IP for management access
    }
  }

  # Diagnostic Interface (nic3)
  network_interface {
    subnetwork = google_compute_subnetwork.diagnostic.name
    network_ip = var.ftdv_egress_diagnostic_ip
  }

  metadata = {
    startup-script = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
      admin_password = var.ftdv_admin_password
      hostname       = "GCP-Egress-Firewall"
      fmc_ip         = sccfm_ftd_device.egress-fw.hostname
      reg_key        = sccfm_ftd_device.egress-fw.reg_key
      fmc_nat_id     = sccfm_ftd_device.egress-fw.nat_id
    })
    ssh-keys = "${var.ftdv_admin_username}:${tls_private_key.key_pair.public_key_openssh}"
    serial-port-enable         = "true" 
  }

  tags = ["ftdv-management", "ftdv-diagnostic", "ftdv-outside", "ftdv-inside"]

  labels = merge(var.common_labels, {
    purpose = "egress-firewall"
    tier    = "security"
  })

  description = "Cisco FTDv Egress Firewall for outbound traffic inspection"

  depends_on = [
    sccfm_ftd_device.egress-fw
  ]
}

# Ingress FTDv Firewall
resource "google_compute_instance" "ftdv_ingress" {
  name              = "${var.resource_prefix}-ingress-ftdv"
  machine_type      = var.ftdv_machine_type
  zone              = var.zone
  can_ip_forward    = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ftd.self_link
    }
  }

  # Outside Interface (nic0)
  network_interface {
    subnetwork = google_compute_subnetwork.outside.name
    network_ip = var.ftdv_ingress_outside_ip
    access_config {
      # Ephemeral public IP for internet access
    }
  }

  # Inside Interface (nic1)
  network_interface {
    subnetwork = google_compute_subnetwork.inside.name
    network_ip = var.ftdv_ingress_inside_ip
  }

  # Management Interface (nic2)
  network_interface {
    subnetwork = google_compute_subnetwork.management.name
    network_ip = var.ftdv_ingress_management_ip
    access_config {
      # Ephemeral public IP for management access
    }
  }

  # Diagnostic Interface (nic3)
  network_interface {
    subnetwork = google_compute_subnetwork.diagnostic.name
    network_ip = var.ftdv_ingress_diagnostic_ip
  }

  metadata = {
    startup-script = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
      admin_password = var.ftdv_admin_password
      hostname       = "GCP-Ingress-Firewall"
      fmc_ip         = sccfm_ftd_device.ingress-fw.hostname
      reg_key        = sccfm_ftd_device.ingress-fw.reg_key
      fmc_nat_id     = sccfm_ftd_device.ingress-fw.nat_id
    })
    ssh-keys = "${var.ftdv_admin_username}:${tls_private_key.key_pair.public_key_openssh}"
    serial-port-enable         = "true" 
  }

  tags = ["ftdv-management", "ftdv-diagnostic", "ftdv-outside", "ftdv-inside"]

  labels = merge(var.common_labels, {
    purpose = "ingress-firewall"
    tier    = "security"
  })

  description = "Cisco FTDv Ingress Firewall for inbound traffic inspection"

  depends_on = [
    sccfm_ftd_device.ingress-fw
  ]
}

# East-West FTDv Firewall
resource "google_compute_instance" "ftdv_eastwest" {
  name              = "${var.resource_prefix}-eastwest-ftdv"
  machine_type      = var.ftdv_machine_type
  zone              = var.zone
  can_ip_forward    = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ftd.self_link
    }
  }

  # Outside Interface (nic0)
  network_interface {
    subnetwork = google_compute_subnetwork.outside.name
    network_ip = var.ftdv_eastwest_outside_ip
    access_config {
      # Ephemeral public IP for internet access
    }
  }

  # Inside Interface (nic1)
  network_interface {
    subnetwork = google_compute_subnetwork.inside.name
    network_ip = var.ftdv_eastwest_inside_ip
  }

  # Management Interface (nic2)
  network_interface {
    subnetwork = google_compute_subnetwork.management.name
    network_ip = var.ftdv_eastwest_management_ip
    access_config {
      # Ephemeral public IP for management access
    }
  }

  # Diagnostic Interface (nic3)
  network_interface {
    subnetwork = google_compute_subnetwork.diagnostic.name
    network_ip = var.ftdv_eastwest_diagnostic_ip
  }

  metadata = {
    startup-script = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
      admin_password = var.ftdv_admin_password
      hostname       = "GCP-EastWest-Firewall"
      fmc_ip         = sccfm_ftd_device.eastwest-fw.hostname
      reg_key        = sccfm_ftd_device.eastwest-fw.reg_key
      fmc_nat_id     = sccfm_ftd_device.eastwest-fw.nat_id
    })
    ssh-keys = "${var.ftdv_admin_username}:${tls_private_key.key_pair.public_key_openssh}"
    serial-port-enable         = "true" 
  }

  tags = ["ftdv-management", "ftdv-diagnostic", "ftdv-outside", "ftdv-inside"]

  labels = merge(var.common_labels, {
    purpose = "eastwest-firewall"
    tier    = "security"
  })

  description = "Cisco FTDv East-West Firewall for inter-spoke traffic inspection"

  depends_on = [
    sccfm_ftd_device.eastwest-fw
  ]
}

################################################################################
# CUSTOM ROUTES - Control traffic flow in Inside VPC for spoke connectivity
################################################################################
#<FLAGG>
# Route spoke1 traffic through east-west firewall (inside VPC perspective)
# COMMENTED OUT: This route causes routing loops when imported via VPC peering
# East-west traffic between spokes should be handled through direct peering
# or more specific routes that don't conflict with local routing
#
# resource "google_compute_route" "inside_to_spoke1" {
#   name             = "${var.resource_prefix}-inside-to-spoke1-route"
#   dest_range       = var.spoke1_vpc_cidr
#   network          = google_compute_network.inside_vpc.name
#   next_hop_instance = google_compute_instance.ftdv_eastwest.name
#   next_hop_instance_zone = google_compute_instance.ftdv_eastwest.zone
#   priority         = 100
#   description      = "Route to Spoke1 via East-West firewall from inside VPC"
  
#   depends_on = [
#     google_compute_instance.ftdv_eastwest
#   ]
# }

# # Route spoke2 traffic through east-west firewall (inside VPC perspective)
# resource "google_compute_route" "inside_to_spoke2" {
#   name             = "${var.resource_prefix}-inside-to-spoke2-route"
#   dest_range       = var.spoke2_vpc_cidr
#   network          = google_compute_network.inside_vpc.name
#   next_hop_instance = google_compute_instance.ftdv_eastwest.name
#   next_hop_instance_zone = google_compute_instance.ftdv_eastwest.zone
#   priority         = 100
#   description      = "Route to Spoke2 via East-West firewall from inside VPC"
  
#   depends_on = [
#     google_compute_instance.ftdv_eastwest
#   ]
# }

# Route internet traffic through egress firewall (inside VPC perspective)
resource "google_compute_route" "inside_internet_via_egress" {
  name             = "${var.resource_prefix}-inside-internet-via-egress-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.inside_vpc.name
  next_hop_instance = google_compute_instance.ftdv_egress.name
  next_hop_instance_zone = google_compute_instance.ftdv_egress.zone
  priority         = 800
  description      = "Route internet traffic through egress FTDv from inside VPC"
  
  depends_on = [
    google_compute_instance.ftdv_egress
  ]
}