###############
# Data Sources
###############
data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}


# e.g. https://www.googleapis.com/compute/v1/projects/cisco-public/global/images/cisco-fmcv-7-0-0-94
data "google_compute_image" "cisco" {
  project = "cisco-public"
  name    = var.cisco_product_version
}

data "template_file" "startup_script" {
  count    = var.num_instances
  template = file("${path.module}/templates/${var.day_0_config}")
  vars = {
    admin_password = var.admin_password
    hostname       = "${var.hostname}%{if var.num_instances > 0}-${count.index + 1}%{endif}"
    #hostname = "cisco-fmcv"
  }
}
