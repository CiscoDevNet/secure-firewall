// If you dont provide any value, it will take the default value

// Resorce group Location
location = "eastus"

// This would prefix all the component with this string.
prefix = "cisco-FTDv"

// Limit the Management access to specific source
source_address = "*"

// All the IP Address segment will use this as prefix with .0,.1,.2 and .3 as the 3rd octet
vn_cidr = "10.0.0.0/16"

// ASA Version to be deployed - Please validate the correct version using - 'az vm image list -p cisco -f cisco-ftdv -s ftdv-azure-byol --all'
image_version = "710.3.0"

// Size of the FTDv to be deployed
vm_size = "Standard_D3_v2"

// Resource Group Name
rg_name = "FTDV_RG"

// Instance Name and properties of FTDv
instancename = "cisco-FTDv"

// Count of FTDv to be deployed.
instances = 2