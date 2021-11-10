// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key      = ""

aws_secret_key      = ""

############################################################
#Define New VPC in a specific Region and Avilability Zone 
#############################################################
vpc_name            = "Cisco-FMCv"

region              = "ap-south-1"

fmc_version         = "fmcv-7.0.0"
//Allowed Values = fmcv-6.7.0, fmcv-6.6.4. 

##################################################################################
#Define CIDR
###################################################################################
vpc_cidr             = "172.16.0.0/16"

###########################################################################################
#Define the Instance size for FMC and attach Day0 Configuration
###########################################################################################
//Use fmc_startup_file.txt to define the hostname, admin password and manager configurations 
password            = "P@$$w0rd1234"

//Please refer FMCv datasheet for the supported size 
//https://www.cisco.com/c/en/us/products/collateral/security/firesight-management-center/datasheet-c78-736775.html
fmc_size            = "c5.4xlarge"

key_name            = "cisco-fmc"
