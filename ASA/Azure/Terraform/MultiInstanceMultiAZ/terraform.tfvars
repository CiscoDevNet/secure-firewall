// If you dont provide any value, it will take the default value

// Resorce group Location
location = "eastus2"

// This would prefix all the component with this string.
prefix = "sameesin-Cisco-ASAv"

// Limit the Management access to specific source
source_address = "*"

// All the IP Address segment will use this as prefix with .0,.1,.2 and .3 as the 3rd octet
vn_cidr = "70.0.0.0/16"

// ASA Version to be deployed - Please validate the correct version using - 'az vm image list --offer asav --all'
image_version = "9191.0.0"

// Size of the ASAv to be deployed
vm_size = "Standard_D3_v2"

// Resource Group Name
rg_name = "sameesin-Cisco-RG"

// Instance Name and properties of ASAv
instancename = "sameesin-ASAv"

// Count of ASAv to be deployed.
instances = 3