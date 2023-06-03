###############
# Providers
###############
provider "google" {
  credentials = file("./devnet-terraform.json")
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  credentials = file("./devnet-terraform.json")
  project = var.project_id
  region  = var.region
}

