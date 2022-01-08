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
  network = var.network
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
  network = var.network
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}


resource "google_compute_firewall" "allow-sftunnel-mgmt" {
  name    = "allow-tunnel-mgmt-${random_string.suffix.result}"
  network = var.network
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8305"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}