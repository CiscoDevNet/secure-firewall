######################
# Variable Assignments
######################

# Environment Name - This name will be tagged to all AWS resources
env_name = "ftdv"

# To deploy an FMCv in the mgmt subnet set "create_fmcv" to true. If using cdFMC in CDO set value to false.
# This value must be set!
create_fmcv = false

# AWS Credentials
aws_access_key = ""
aws_secret_key = ""

# AWS Region and Availability Zone
region = "us-west-2"
aws_az = "us-west-2a"

#FMC and FTD Info

# FTD password must be entered
ftd_pass = "FtDv_AuT0Scale"
fmc_username = "autoscale-admin"
ngfw_password = "123Cisco@123!"
fmc_password = "123Cisco@123!"
fmc_metrics_username = "metric-admin"
fmc_metrics_password = "123Cisco@123!"

# Enter cdFMC FQDN if "create_fmcv" is set to false.
cdFMC = ""
cdo_token = ""

# ftd reg key and nat id are needed for both FMCv and cdFMC deployments
ftd_reg_key = "cisco"
ftd_nat_id  = "cisco"

auto_scale_desired_group_size = 0

notify_email = ""
