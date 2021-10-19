############################
## External Load Balancer ##
############################
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}
resource "google_compute_forwarding_rule" "asa-ext-fr" {
  name                  = "asa-ext-fr-${random_string.suffix.result}"
  project               = var.project_id
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.service_port
  backend_service       = google_compute_region_backend_service.asa-region-be-ext.id
}


resource "google_compute_region_backend_service" "asa-region-be-ext" {
  name          = "asa-region-be-ext-${random_string.suffix.result}"
  project       = var.project_id
  region        = var.region
  health_checks = [google_compute_region_health_check.ssh-health-check.self_link]

  load_balancing_scheme = "EXTERNAL"
  protocol              = "TCP"
  port_name             = "http"
  timeout_sec           = 10


  dynamic "backend" {
    for_each = toset(local.backends)
    iterator = backend
    content {
      balancing_mode = "CONNECTION"
      description    = "Terraform managed instance group for ASA."
      group          = backend.key
    }
  }
}

############################
## Health Check ##
############################
resource "google_compute_region_health_check" "ssh-health-check" {
  name        = "ssh-health-check-${random_string.suffix.result}"
  description = "Terraform managed."
  project     = var.project_id
  region      = var.region

  timeout_sec         = 5
  check_interval_sec  = 15
  healthy_threshold   = 4
  unhealthy_threshold = 5

  tcp_health_check {
    port = "22"
  }
}


############################
## Internal Load Balancer ##
############################

resource "google_compute_forwarding_rule" "asa-int-fr" {
  count = var.use_internal_lb ? 1 : 0

  name                  = "asa-int-fr-${random_string.suffix.result}"
  project               = var.project_id
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network_tier          = "PREMIUM"
  allow_global_access   = var.allow_global_access

  network    = var.networks_map[var.inside_network].network_self_link
  subnetwork = var.networks_map[var.inside_network].subnet_self_link
  # service_label         = var.service_label
  backend_service = google_compute_region_backend_service.asa-region-be-int.id
  #all_ports             = true
  ports = [var.service_port]
}


resource "google_compute_region_backend_service" "asa-region-be-int" {
  name          = "asa-region-be-int-${random_string.suffix.result}"
  project       = var.project_id
  region        = var.region
  health_checks = [google_compute_region_health_check.ssh-health-check.self_link]

  load_balancing_scheme = "INTERNAL"
  protocol              = "TCP"
  # network is needed for ILB
  network = var.networks_map[var.inside_network].network_self_link

  dynamic "backend" {
    for_each = toset(local.backends)
    iterator = backend
    content {
      balancing_mode = "CONNECTION"
      description    = "Terraform managed instance group for ASA."
      group          = backend.key
    }
  }
}