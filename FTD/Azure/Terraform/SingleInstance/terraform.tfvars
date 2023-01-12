// If you dont provide any value, it will take the default value

// Resorce group Location
location = "centralindia"

// This would prefix all the component with this string.
prefix = "Cisco-FTDv"

// Limit the Management access to specific source
source-address = "*"

// All the IP Address segment will use this as prefix with .0,.1,.2 and .3 as the 3rd octet
IPAddressPrefix = "10.10"

// ASA Version to be deployed - Please validate the correct version using - 'az vm image list --offer asav --all'
Version = "72082.0.0"

// Size of teh FTDv to be deployed
VMSize = "Standard_D3_v2"

// Resource Group Name
RGName = "Cisco-FTDv-RG"

// Instance Name and properties of FTDv
instancename = "ftdv"

password = "Cisco@123"
