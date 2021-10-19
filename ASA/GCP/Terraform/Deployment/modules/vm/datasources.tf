###############
# Data Sources
###############
data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}


# e.g. https://www.googleapis.com/compute/v1/projects/cisco-public/global/images/cisco-asav-9-16-1-28
data "google_compute_image" "asa" {
  project = "cisco-public"
  name    = var.cisco_product_version
}

data "template_file" "startup_script" {
  template = file("${path.module}/templates/${var.day_0_config}")
  #template = var.day_0_config
  vars = {
    enable_password = var.enable_password
  }
}
