This module simplifies the deployment of [Cisco FTD in OCI](https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/oci/ftdv-oci-gsg/ftdv-oci-deploy.html).

## FTD version supported

* 7.x

## Compatibility

This module is meant for use with Terraform version >=1.0.0.

# Prerequisites

You should complete below pre-requisites before proceeding to next section:
- You have an active Oracle Cloud Infrastructure Account.
  - Tenancy OCID, User OCID, Compartment OCID, Private and Public Keys are setup properly.
- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-lists`, `subnets` and `instances`.
- Quota to create the following resources: 4 VCNs, 4 subnets, and 2 compute instances.

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## OCI Resource managed

* New VCN networks, internet gateway, route table, subnets and security lists would be created.
* A single instance or a number of instances would be created depending on use case.

## Customize ssh key pair

```bash
# Generate a ssh key pair with 2048 bits key as 2048 bits is supported
ssh-keygen -t rsa -b 2048 -f admin-ssh-key
```

Then replace the **admin-ssh-key** public key in the terraform variable file.

## Customize security list

* To customize it, please change [security list](modules/networking/main.tf).

## Deploy Using Oracle Resource Manager

In this section you will follow each steps given below to create this architecture:

1. You can use the zip file under *resource-manager* to create a stack according to [ Deploy to Oracle Cloud](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/managingstacksandjobs.htm#StackManaging). 

2. After creating the stack, click **Terraform Actions**, and select **Plan** from the stack on OCI console UI.

3. Wait for the job to be completed, and review the plan.

    > To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

4. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

5. At this stage your architecture should have been deployed successfully. You can proceed to next section for configuring your Cisco VM Series Firewall.

6. If you no longer require your infrastructure, return to the Stack Details page and **Terraform Actions**, and select **Destroy**.

## Cisco CLI validation

VM_IP_ADDRESS can be obtained from Oracle Cloud console.

FTD SSH session
```bash
ssh -i admin-ssh-key admin@VM_IP_ADDRESS
```


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
## Source code files naming convention

* locals.tf: local variables
* variables.tf: input variables
* outputs.tf: output variables
* datasource.tf: define data source such as zones, compute images and template.
* network.tf: define VCN networks, custom routes.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| mgmt_network | The name of management VCN network | string | - | yes |
| diag_network | The name of diag VCN network | string | - | yes|
| outside_network | The name of outside VCN network | string | - | yes |
| inside_network | The name of inside VCN network | string | - | yes |
| dmz_network | The name of dmz VCN network | string | - | no|
| num_instances | Number of instances to create | number | 1 | yes |
| multiple_ad | multiple AD or not | bool | false | yes|
| label_prefix | a string that will be prepended to all resources | string | ftd | no |
| vm_compute_shape | The machine type of the instance | string | VM.Standard2.8  | yes |
| mp_listing_resource_id | product version of ftd in OCI market place | string| the ftd product id in marketplace | yes |
| day_0_config | The zero day configuration file name, under templates folder|string| startup_file.json | no |
| admin_ssh_pub_key| ssh public key for admin user | string| - | yes |
| admin_password | ftd admin password | string | - | yes | 
| hostname |  FTD hostname | string | cisco-ftd | no |
| network_x_name (where x is 1 to 4) | Name assigned to the VCN created | string | - | yes |
| network_x_vcn_cidr (where x is 1 to 4) | CIDR of the VCN created | string | - | yes |
| network_x_subnet_cidr (where x is 1 to 4) | CIDR of the subnet created | string | - | yes |
| network_x_private_ip (where x is 1 to 4) | IP Addresses to be assigned to the instances created | list(string) | - | yes |
| network_x_external_ip (where x is 1 to 4) | If public ip needs to be assigned to the nic in this subnet | boolean | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| networks\_list| The internal networks data structure used|
| vm_external\_ips | The external IPs of the vm instances|
| vm_private\_ips | The private IPs of the vm instances's nic0|