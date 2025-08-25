################
# Providers
################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    fmc = {
      source = "CiscoDevNet/fmc"
      version = ">=1.2.4"
    }
  }
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     =  var.region
}

provider "fmc" {
  fmc_username = local.fmc_user
  fmc_password = local.fmc_pass
  fmc_host = local.fmc_host
  fmc_insecure_skip_verify = var.fmc_insecure_skip_verify
  is_cdfmc  = local.is_cdfmc
  cdo_token = local.cdo_token
  cdfmc_domain_uuid = local.cdfmc_domain_uuid
}