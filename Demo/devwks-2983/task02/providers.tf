###############
# Providers
###############
provider "google" {
  credentials = file("your_sa_authentication.json")
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  credentials = file("your_sa_authentication.json")
  project = var.project_id
  region  = var.region
}

