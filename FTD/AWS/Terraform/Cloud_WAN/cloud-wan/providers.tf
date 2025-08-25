terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
    ##############################################################################
    ## Comment this section to SKIP the FMC Configuration                       ##
    ##############################################################################
    fmc = {
      source  = "CiscoDevNet/fmc"
      version = "<= 1.5.2"
    }
    ##############################################################################
    ##############################################################################
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

##############################################################################
## Comment this section to SKIP the FMC Configuration                       ##
##############################################################################
provider "fmc" {
  fmc_username             = var.fmc_username
  fmc_password             = var.fmc_password
  fmc_host                 = var.fmc_mgmt_ip
  fmc_insecure_skip_verify = var.fmc_insecure_skip_verify
}
##############################################################################
##############################################################################