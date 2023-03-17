<!-- BEGIN_TF_DOCS -->
# Create Resouce Group module

## Overview

Create Resouce Group to manage the resources and create resources under the same resource group

## Module Name
resource group (rg)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="create_rg"></a> [create_rg](#create_rg) | create resource group| `boolean` |`""`| yes |
| <a name="rg_name"></a> [resource group name](#rg_name) | Specify resource group name | `string` |`""`| yes |
| <a name="location"></a> [location](#location) |Specify location | `string` |`""`| yes|
| <a name="tags"></a> [tags](#tags) |Specify tags name for the resources | `map(string)` | dev | yes|
  
    
      


## Outputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="resource_group_name"></a> [resource_group_name](#resource_group_name) | Name of the resource group| `string` |`""`| yes |
| <a name="location"></a> [location](#location) | Location | `string` |`""`| yes |
| <a name="resource_group_id"></a> [resource_group_id](#resource_group_id) |Id of the resource group | `string` |`""`| yes|


<!-- END_TF_DOCS -->