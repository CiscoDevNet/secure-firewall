############################
## management VPC ##
############################
resource "google_compute_firewall" "allow-ssh-mgmt" {
  name    = "devnet-pod01-fmc-allow-ssh-mgmt"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = ["173.0.0.0/8"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-HTTPS-mgmt" {
  name    = "devnet-pod01-fmc-allow-https-mgmt"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges           = ["173.0.0.0/8"]
  #source_ranges           = ["173.0.0.0/8", "10.0.0.0/8"]
  target_service_accounts = [var.service_account]
}
resource "google_compute_firewall" "allow-icmp-mgmt" {
  name    = "devnet-pod01-fmc-allow-icmp-mgmt"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "icmp"
  }

  source_ranges           = ["173.0.0.0/8"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-tunnel-mgmt" {
  name    = "devnet-pod01-fmc-allow-tunnel-mgmt"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8305"]
  }

  source_ranges           = ["173.0.0.0/8","10.0.0.0/8"]
  target_service_accounts = [var.service_account]
}


############################
## outside VPC ##
############################

resource "google_compute_firewall" "allow-ssh-outside" {
  name    = "devnet-pod01-allow-tcp-outside"
  network = module.vpc-module[var.outside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = ["173.0.0.0/8"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-http-outside" {
  name    = "devnet-pod01-allow-http-outside"
  network = module.vpc-module[var.outside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges           = ["173.0.0.0/8"]
  target_service_accounts = [var.service_account]
}

############################
## inside VPC ##
############################

resource "google_compute_firewall" "allow-ssh-inside" {
  name    = "devnet-pod01-allow-tcp-inside"
  network = module.vpc-module[var.inside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges           = ["173.0.0.0/8"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-http-inside" {
  name    = "devnet-pod01-allow-http-inside"
  network = module.vpc-module[var.inside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges           = ["173.0.0.0/8"]
  target_service_accounts = [var.service_account]
}
