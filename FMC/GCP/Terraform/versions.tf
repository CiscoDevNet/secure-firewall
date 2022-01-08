terraform {
  required_version = ">=1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "<4.0,>= 3.79"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "<4.0,>= 3.79"
    }

    template = {
      version = ">= 2.2.0"
    }
    random = {
      version = ">= 3.1.0"
    }

  }
}
