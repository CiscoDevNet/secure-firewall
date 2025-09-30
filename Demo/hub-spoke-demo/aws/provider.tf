terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
    sccfm = {
      source = "CiscoDevnet/sccfm"
      version = "0.2.5"
    }
    fmc = {
      source = "CiscoDevNet/fmc"
      version = "2.0.0-rc6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
provider "sccfm" {
  api_token = var.scc_token
  base_url  = var.scc_host
}

provider "fmc" {
  url     = "https://${var.cdfmc_host}"
  token   = var.scc_token
}