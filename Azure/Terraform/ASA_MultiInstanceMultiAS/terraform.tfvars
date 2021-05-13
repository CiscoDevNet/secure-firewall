// If you dont provide any value, it will take the default value

// Resorce group Location
location = "centralindia"

// This would prefix all the component with this string.
prefix = "cisco-ASAv"

// Limit the Management access to specific source
source-address = "*"

// All the IP Address segment will use this as prefix with .0,.1,.2 and .3 as the 3rd octet
IPAddressPrefix = "10.10"

// ASA Version to be deployed - Please validate the correct version using - 'az vm image list --offer asav --all'
Version = "915.1.1"

// Size of the ASAv to be deployed
VMSize = "Standard_D3_v2"

// Resource Group Name
RGName = "cisco-ASAv-RG"

// Instance Name and properties of ASAv
instancename = "cisco-ASAv"

// Count of ASAv to be deployed.
instances = 2