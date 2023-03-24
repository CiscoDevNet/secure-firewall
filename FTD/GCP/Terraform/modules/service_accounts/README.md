This is a module for [Cisco FMC in GCP](https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/fmcv/fpmc-virtual/fpmc-virtual-gcp.html). 


## Compatibility

This module is meant for use with Terraform version >=1.0.0.

## Use cases
This module will be used to create a new service account on GCP. This service account will be used for all the configurations that is being created by both the example use-cases. 

## Source code files naming convention

* variables.tf: input variables
* outputs.tf: output variables 

## Inputs

Primarily all the input variables are to be changed from the terraform.tfvars files in examples only, these are described here just for convenience.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| sa_account_id | The ID of the service account that this module will create | string | "terraform-managed-sa" | yes |
| sa_display_name | Service account display name | string | "Terraform-managed-sa" | yes |
| sa_description| Service account description | list| "Temp SA for terraform"| yes |

## Outputs

| Name | Description |
|------|-------------|
| email | The email address of the service account to be used by networking module |
