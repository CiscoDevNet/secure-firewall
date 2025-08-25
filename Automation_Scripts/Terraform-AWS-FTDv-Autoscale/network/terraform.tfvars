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
ngfw_password = "FtDv_AuT0Scale"
fmc_password = "FtDv_AuT0Scale"
fmc_metrics_username = "metric-admin"
fmc_metrics_password = "FtDv_AuT0Scale"

# Enter cdFMC FQDN if "create_fmcv" is set to false.
cdFMC = "cisco-brebouch.app.us.cdo.cisco.com"
cdo_token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXIiOiIwIiwic2NvcGUiOlsidHJ1c3QiLCI3MWYwYTJlMy1jNzQ5LTQxNmEtODE4NS1lNmM2MmQzM2UwOGEiLCJyZWFkIiwid3JpdGUiXSwiYW1yIjpudWxsLCJyb2xlcyI6WyJST0xFX1NVUEVSX0FETUlOIl0sImlzcyI6Iml0ZCIsImNsdXN0ZXJJZCI6IjEiLCJpZCI6IjI4NDM5NWIwLWVlOWYtNDQzYy1hMjQ2LTc2MjYxN2YzNmE2MyIsInN1YmplY3RUeXBlIjoidXNlciIsImp0aSI6ImNjYzViNTc3LTE2MzQtNGI4ZC1iMzJkLTRkYmNkNDI3ZWIwYyIsInBhcmVudElkIjoiNzFmMGEyZTMtYzc0OS00MTZhLTgxODUtZTZjNjJkMzNlMDhhIiwiY2xpZW50X2lkIjoiYXBpLWNsaWVudCJ9.1H0vKBw0JiCnZvmlJy7LSVPulEW4HZHp-ePb670EBLihJ4GWFxsjKw5uWIv3eA6OqU3Akgl_7LXR9RDxnnj0-UULLWJddt5r4qP1AdIlMfuby4Q-Qw7FIK7TLk79ODyLAPm9oLEe3yrOmdigcD9MxbmNW9G4WnBmNPUIrRKlTKwNDFaMiZxdTmJj0DzY23975Iqs-hGAWESt279mKT43d7hg8rD3KKSl11LvYfTuraLOe2kXM65hZi6eVmjqDoHD3ew8CCSAdwKzF9esXmWcdvFmfWUALLGmhpK7h01AqaUyUBrE4X8NdggT-ToFNOahVx-ZbXjCvGhzJn4bVLAb_g"
cdfmc_domain_uuid = "e276abec-e0f2-11e3-8169-6d9ed49b625f"
# ftd reg key and nat id are needed for both FMCv and cdFMC deployments
ftd_reg_key = "cisco"
ftd_nat_id  = "cisco"

fmc_policy_name = "ftd-policy-test"
fmc_intrusion_policy_name = "ftd-ips-policy-test"

auto_scale_desired_group_size = 1

notify_email = "brebouch@cisco.com"
