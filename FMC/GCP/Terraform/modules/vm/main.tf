resource "random_shuffle" "available_zones" {
  input        = data.google_compute_zones.available.names
  result_count = local.num_zones
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

#############################################
# Instances
# https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/fmcv/fpmc-virtual/fpmc-virtual-gcp.html
#############################################
resource "google_compute_instance" "fmc" {
  count                     = var.num_instances
  provider                  = google
  project                   = var.project_id
  name                      = "${var.hostname}-${count.index + 1}-${random_string.suffix.result}"
  zone                      = element(random_shuffle.available_zones.result, count.index % local.num_zones)
  machine_type              = var.vm_machine_type
  can_ip_forward            = true
  allow_stopping_for_update = true
  tags                      = try(var.vm_instance_tags, [])
  labels                    = try(var.vm_instance_labels, {})

  boot_disk {
    initialize_params {
      image = data.google_compute_image.cisco.self_link
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  metadata = {
    ssh-keys       = var.admin_ssh_pub_key
    startup-script = data.template_file.startup_script[count.index].rendered
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork         = var.subnet_self_link
    subnetwork_project = var.network_project_id
    network_ip         = var.appliance_ips[count.index]
    access_config {
      nat_ip       = null
      network_tier = "PREMIUM"
    }
  }
}