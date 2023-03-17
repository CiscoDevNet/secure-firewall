###############
# Providers
###############
provider "google" {
  #credentials = file("./gcp-creds.json")
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

