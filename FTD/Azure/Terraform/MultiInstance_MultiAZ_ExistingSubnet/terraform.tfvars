// If you dont provide any value, it will take the default value

// Resorce group Location
location = "eastus"

// This would prefix all the component with this string.
prefix = "Cisco-FTDv"

// Limit the Management access to specific source
source_address = "*"

// ASA Version to be deployed - Please validate the correct version using - 'az vm image list -p cisco -f cisco-ftdv -s ftdv-azure-byol --all'
image_version = "700.94.0"

// Size of the FTDv to be deployed
vm_size = "Standard_D3_v2"

// Resource Group Name
rg_name = "FTD_RG"

// Virtual Network Name
vn_name = "FTD-vnet"

// Instance Name and properties of FTDv
instancename = "cisco-FTDv"

// Count of FTDv to be deployed.
instances = 2

//Subnet names to be used by FTDv instance
management_subnet = "mgmt"

diagnostic_subnet = "diag"

outside_subnet    = "outside"

inside_subnet     = "inside"

