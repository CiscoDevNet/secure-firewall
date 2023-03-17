This module simplifies the deployment of for [Cisco FTD in GCP](https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/gcp/ftdv-gcp-gsg/ftdv-gcp-deploy.html).

## FTD version supported

* 7.x

## Compatibility

This module is meant for use with Terraform version >=1.0.0.

## Prerequisites

Install gcloud and authenticate by running the following command
```bash
gcloud auth application-default login
```

Additionally, Google cloud project credentials can be used following this link: 
[Getting started with Terraform on Google Cloud](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform)

## Examples

Examples of how to use these modules can be found in the [examples](examples/) folder.
- [single FTDv instance use case](examples/single-instance/terraform.tfvars.example)


## GCP Resource managed

* New VPC networks, subnets and firewall rules would be created.
* A service account is created and is used as target for firewall rules.
* A single instance or a number of instances would be created depending on use case.

### (Optional) Set up a GCS backend

```bash
cd examples/single-instance
```

Add backend.tf accordingly,

```hcl
terraform {
  backend "gcs" {
    bucket = "<a-unique-bucket-for-terraform-states>"
    prefix = "ftd/single-instance"
  }
}
```

## Customize ssh key pair

```bash
# Generate a ssh key pair with 2048 bits key as 2048 bits is supported by ASA
ssh-keygen -t rsa -b 2048 -f admin-ssh-key
```

Then replace the **admin-ssh-key** public key in the terraform variable file.

## Customize firewall rules

![Firewall rules](images/firewall-rules.png).

* Firewall rules would be created as shown.
* Management network allows TCP port 22 and 8305 while other networks allow all TCP ports by default.
* To customize it, please change [firewall.tf](modules/networking/firewall.tf).

## Customize service account

`account_id` is the GCP service account, it can be customized for different deployment if desired.

A service account is a special type of Google Account that represents a Google Cloud service identity or app rather than an individual user. Like users and groups, service accounts can be assigned IAM roles to grant access to specific resources. Service accounts authenticate with a key rather than a password. Google manages and rotates the service account keys for code running on Google Cloud. We recommend that you use service accounts for server-to-server interactions.

Please don't use the default compute engine service account which has the project editor role by default, obviously too permissive. The template would create a service account.

## Customize routes

[networking/main.tf](modules/networking/main.tf) can be changed. Currently left out for various customization.

## Deploy Using the Terraform CLI

```bash
cd examples/single-instance
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform destroy
```
## Cisco CLI validation

FTD SSH session
```bash
IP_ADDRESS=$(terraform output -json vm_external_ips  | jq -r '.[0][0]')
ssh -i admin-ssh-key admin@$IP_ADDRESS
```
![SSH](images/ssh.png)

### A note on SSH RSA SHA-1

[OpenSSH release 8.8 and up](https://www.openssh.com/txt/release-8.8) disables RSA signatures using the SHA-1 hash algorithm by default.
If you run into an error: `Unable to negotiate with 34.83.229.123 port 22: no matching host key type found. Their offer: ssh-rsa`
Check if the SSH client with `ssh -V` and see if it is 8.8 up, then you can re-enable RSA/SHA1 to allow connection and/or user
authentication via the HostkeyAlgorithms and PubkeyAcceptedAlgorithms.
```bash
~/.ssh/config
Host x.y.z.x
   HostkeyAlgorithms +ssh-rsa
   PubkeyAcceptedAlgorithms +ssh-rsa
```

Alternatively ```ssh -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa  -i admin-ssh-key admin@${IP_ADDRESS}``` works too.


## MultiNic VM

* *google_compute_instance* uses the first network interface as nic0.
* *mgmt_network* is required for VM's nic0.

## Source code files naming convention

* locals.tf: local variables
* variables.tf: input variables
* outputs.tf: output variables
* datasource.tf: define data source such as zones, compute images and template.
* network.tf: define VPC networks, custom routes.
* firewall.tf: define firewall rules.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the project where VPC networks will be created | string | - | yes |
| region | The region of the VPC networks will be created | string | - | yes |
| networks | A list of VPC network related data such as name, cidr range, appliance ip, has external ip or not  | `list`| [] | no |
| mgmt_network | The name of management VPC network | string | vpc-mgmt | no |
| diag_network | The name of dmz2 VPC network | string | vpc-diag | no|
| outside_network | The name of outside VPC network | string | vpc-mgmt | no|
| inside_network | The name of inside VPC network | string | vpc-inside | no |
| dmz_network | The name of dmz VPC network | string | vpc-dmz | no|
| num_instances | Number of instances to create | number | 1 | no |
| vm_zones | zones of vm instances | string | - | yes |
| vm_machine_type | The machine type of the instance | string | - | yes |
| vm\_instance\_labels | Labels to apply to the vm instances. | `map(string)` | `{}` | no |
| vm\_instance\_tags | Additional tags to apply to the instances.| `list(string)` | `[]` | no |
| cisco_product_version | product version of cisco appliance | string| - | no |
| day_0_config | The zero day configuration file name, under templates folder|string| - | yes |
| admin_ssh_pub_key| ssh public key for admin user | string| - | yes |
| custom_route_tag | custom route tag for the appliance | string | false | no |
| hostname |  FTD hostname | string | ftd | no |
| admin_password | ftd admin password | string | - | yes | 

## Outputs

| Name | Description |
|------|-------------|
| networks\_map| The internal networks data structure used|
| vm_external\_ips | The external IPs of the vm instances|
| external\_lb_ip | The IP of external load balancer |
| internal\_lb_ip | The IP of internal load balancer |
