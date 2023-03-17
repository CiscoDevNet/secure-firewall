// If you dont provide any value, it will take the default value

// Resorce group Location
location = "eastus2"

// This would prefix all the component with this string.
prefix = "Cisco-ASAv"

// Resource Group Name
rg_name = "Cisco-ASAv-RG"

//vnet name
vn_name = "Cisco-ASAv-Vnet"

// Limit the Management access to specific source
source_address = "*"

// Count of ASAv to be deployed.
instances = 1

// Size of the ASAv to be deployed
vm_size = "Standard_D3_v2"

// Instance Name and properties of ASAv
instancename = "ASAv"

// ASA Version to be deployed - Please validate the correct version using - 'az vm image list --offer asav --all'
image_version = "9191.0.0"
//Name of subnets to be used for ASAv interfaces
management_subnet = "mgmt"

external_subnet   = "external"

internal_subnet   = "internal"



