terraform {
  required_version = ">=1.0.0"

  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 4.46.0"
    }

    template = {
      version = "~> 2.2.0"
    }

  }
}
