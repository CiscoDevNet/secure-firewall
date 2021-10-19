# Data source for list of google IPs
data "google_compute_lb_ip_ranges" "ranges" {
  # hashicorp/terraform#20484 prevents us from depending on the service
}

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


resource "google_compute_firewall" "allow-service-port-mgmt" {
  name    = "allow-service-port-mgmt-${random_string.suffix.result}"
  network = module.vpc-module[var.mgmt_network].network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = [var.service_port]
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
  }

  # allow the same subnet and google load balancer ip range
  #source_ranges = concat([local.networks[var.inside_network].cidr], data.google_compute_lb_ip_ranges.ranges.network)
  # can be customized
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}



# resource "google_compute_firewall" "allow-service-inside" {
#   count   = var.ha_enabled ? 1 : 0
#   name    = "allow-service-port-inside"
#   network = module.vpc-module[var.inside_network].network_name
#   project = var.project_id

#   allow {
#     protocol = "tcp"
#     ports    = [var.service_port]
#   }

#   # can be customized
#   source_ranges           = ["0.0.0.0/0"]
#   target_service_accounts = [var.service_account]
# }



############################
## outside VPC ##
############################
resource "google_compute_firewall" "allow-ssh-outside" {
  count   = local.enable_outside_network ? 1 : 0
  name    = "allow-tcp-outside-${random_string.suffix.result}"
  network = try(module.vpc-module[var.outside_network].network_name, var.outside_network)
  project = var.project_id

  allow {
    protocol = "tcp"
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [var.service_account]
}

# resource "google_compute_firewall" "allow-service-outside" {
#   count   = local.enable_outside_network ? 1 : 0
#   name    = "allow-service-port-outside"
#   network = try(module.vpc-module[var.outside_network].network_name, var.outside_network)
#   project = var.project_id

#   allow {
#     protocol = "tcp"
#     ports    = [var.service_port]
#   }

#   # can be customized
#   source_ranges           = ["0.0.0.0/0"]
#   target_service_accounts = [var.service_account]
# }