locals {
  #num_zones = length(data.google_compute_zones.available.names)
  # zone    = data.google_compute_zones.available.names[count.index % local.num_zones]

  # backends defined for LB
  backends = [for x in google_compute_instance_group.asa : x.self_link]
}
data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}

resource "google_compute_instance_group" "asa" {
  count   = var.num_instances
  name    = "asa-${count.index + 1}-${random_string.suffix.result}"
  project = var.project_id
  zone    = var.vm_zones[count.index]
  instances = [
    var.instance_ids[count.index],
  ]

  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }
}
