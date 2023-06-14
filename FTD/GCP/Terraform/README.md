This is a module for [Cisco FMC in GCP](https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/fmcv/fpmc-virtual/fpmc-virtual-gcp.html). 


## Compatibility

This module is meant for use with Terraform version >=1.0.0.

## FMC version supported
* 7.3

## Use cases
Terraform plan will create a pair of FTD & FMC on GCP based on the following configurations: 
* ### Single FTD & Single FMC: 
  When **num_instances** input variable is **1**, the terraform creates only one FTD & FMC.
* ### Multiple FTDs & Single FMC:
  When **num_instances** input variable is **2**, the terraform creates two FTDs & FMC.

  Extra appliance_ips are passed to the list "network" to support the increased number of instances.
## Example usage
Examples of how to use these modules can be found in the [examples](examples/) folder.
- [Single instance](examples/single-instance)
- [Mutiple instance](examples/multi-instance)

### (Optional) Set up a GCS backend
```bash
cd examples/single-instance
```
Add backend.tf accordingly,

```hcl
terraform {
  backend "gcs" {
    bucket = "<a-unique-bucket-for-terraform-states>"
    prefix = "fmc/single-instance"
  }
}
```

### Generate a ssh key pair with 2048 bits key as 2048 bits is supported by FMC.


```bash
# Generate a ssh key pair with 2048 bits key as 2048 bits is supported by ASA
ssh-keygen -t rsa -b 2048 -f admin-ssh-key
```

### Execute Terraform for creating the appliances.

```bash
cd examples/single-instance
# modify the  terraform.tfvars to make sure all the values fit the use case 
# such as admin_ssh_pub_key
terraform init 
terraform plan
terraform apply
terraform destroy
```
### Screenshots of SSH and HTTPS UI
FMC SSH session
```bash
IP_ADDRESS=$(terraform output -json vm_external_ips  | jq -r '.[0]')
ssh -i admin-ssh-key admin@$IP_ADDRESS
```

Please go to FMC GUI via *https://${IP_ADDRESS}/* in a browser.
![FMC GUI](images/fmc_ui.png)

## Source code files naming convention

* locals.tf: local variables
* variables.tf: input variables
* outputs.tf: output variables
* datasource.tf: define data source such as zones, compute images and template.
* network.tf: define VPC networks, custom routes.
* firewall.tf: define firewall rules.

## Inputs

## Inputs

To be changed from terraform.tfvars as per the requirements.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the project where VPC networks will be created | string | - | yes |
| region | The region of the VPC networks will be created | string | - | yes |
| network| List of all network names,CIDR & Appliance IP | list| - | yes |
| appliance_ips (under network list)| internal IP address of the cisco appliances | string | "" | yes|
| appliance_ips_fmc| internal IP address of the FMCv | string | "" | yes|
| num_instances | Number of instances to create | number | 1 | yes |
| vm_machine_type | The machine type of the instance | string | "e2-standard-4" | yes |
| fmc_hostname |  FMC hostname | string | fmc | no |
| ftd_hostname |  FTD hostname | string | ftd | no |
| vm\_instance\_labels | Labels to apply to the vm instances. | `map(string)` | `{}` | no |
| boot_disk_size | boot disk size in GB | string | 250 | no |
| boot_disk_type | boot disk type | string | pd-ssd | no |
| cisco_product_version | product version of cisco appliance | string| "cisco-ftdv-7-3-0-69" | no |
| day_0_config | The zero day configuration file name, under templates folder|string| - | no |
| admin_password | fmc admin password | string | - | no | 
| admin_ssh_pub_key| ssh public key for admin user | string| - | Yes |
## Outputs

| Name | Description |
|------|-------------|
| FMC_Public_IP | The external IP of FMC |
| FTD_Public_IP| The external IPs of FTDs|
    
    

> **_NOTE:_ NIC Mapping to Data Interfaces**     

 
On Secure Firewall version 7.1 and earlier releases, the mapping of Network Interface Cards (NICs) to data interfaces is as given below:

nic0 – Management interface

nic1 – Diagnostic interface

nic2 – Gigabit Ethernet 0/0

nic3 – Gigabit Ethernet 0/1

From Secure Firewall version 7.2, a data interface is required on nic0 to facilitate movement of north-south traffic because the external load balancer (ELB) forwards packets only to nic0.

The mapping of NICs and data interfaces on Secure Firewall version 7.2 is as given below:

nic0 – Gigabit Ethernet 0/0

nic1 – Gigabit Ethernet 0/1

nic2 – Management interface

nic3 – Diagnostic interface

nic4 – Gigabit Ethernet 0/2

.

.

.

nic(N-2) – Gigabit Ethernet 0/N-4

nic(N-1) – Gigabit Ethernet 0/N-3
