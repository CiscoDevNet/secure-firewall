// If you dont provide any value, it will take the default value

// Resorce group Location
location = "eastus2"

// This would prefix all the component with this string.
prefix = "Cisco-FTDv"

// Limit the Management access to specific source
source-address = "*"

// ASA Version to be deployed - Please validate the correct version using - 'az vm image list --offer asav --all'
Version = "700.94.0"

// Size of teh FTDv to be deployed
VMSize = "Standard_D3_v2"

// Resource Group Name
rg_name = ""

//Virtual Network Name
vn_name = ""

//Subnets Name
management_subnet = ""

diagnostic_subnet = ""

outside_subnet = ""

inside_subnet = ""

// Instance Name and properties of FTDv
instancename = "FTDv"

username = "cisco"

password = "Cisco@1234"