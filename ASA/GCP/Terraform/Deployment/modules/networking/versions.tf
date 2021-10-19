terraform {
  required_version = ">=1.0.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.79, <4.0"
    }
  }
}
