resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

############################
## management VPC ##
############################
resource "google_compute_firewall" "allow-ssh-mgmt" {
  name    = "allow-ssh-mgmt-${random_string.suffix.result}"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-https-mgmt" {
  name    = "allow-https-mgmt-${random_string.suffix.result}"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-tunnel-mgmt" {
  name    = "allow-tunnel-mgmt-${random_string.suffix.result}"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8305"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}


############################
## outside VPC ##
############################

resource "google_compute_firewall" "allow-ssh-outside" {
  name    = "allow-tcp-outside-${random_string.suffix.result}"
  network = module.vpc-module[var.outside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-http-outside" {
  name    = "allow-http-outside-${random_string.suffix.result}"
  network = module.vpc-module[var.outside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}

############################
## inside VPC ##
############################

resource "google_compute_firewall" "allow-ssh-inside" {
  name    = "allow-tcp-inside-${random_string.suffix.result}"
  network = module.vpc-module[var.inside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}

resource "google_compute_firewall" "allow-http-inside" {
  name    = "allow-http-inside-${random_string.suffix.result}"
  network = module.vpc-module[var.inside_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}
