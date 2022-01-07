This module simplifies the deployment of [Cisco ASAv in OCI](https://www.cisco.com/c/en/us/td/docs/security/asa/asa917/asav/getting-started/asav-917-gsg/asav_oci.html).

## ASA version supported

* 9.x

## Compatibility

This module is meant for use with Terraform version >=1.0.0.

## Prerequisites

You should complete below pre-requisites before proceeding to next section:
- You have an active Oracle Cloud Infrastructure Account.
  - Tenancy OCID, User OCID, Compartment OCID, Private and Public Keys are setup properly.
- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-lists`, `subnets`, `network-load-balancers` and `instances`.
- Quota to create the following resources: 4 VCNs, 4 subnets, 2 compute instances and 2 Load balancers.

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## OCI Resource managed

* New VCN networks, route table, subnets and security lists would be created.
* A single instance or multiple instances of ASAv would be created depending on use case.
* A public and a private Network load balancer are created depending on use case.


## Customize ssh key pair

```bash
# Generate a ssh key pair with 2048 bits key as 2048 bits is supported by ASA
ssh-keygen -t rsa -b 2048 -f admin-ssh-key
```

Then replace the **admin-ssh-key** public key in the terraform variable file.


## Customize security list

* To customize it, please change [security list](modules/networking/main.tf).


## Deploy Using Oracle Resource Manager

In this section you will follow each steps given below to create this architecture:
1. You can use the zip file under *resource_manager* to create a stack according to [ Deploy to Oracle Cloud](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/managingstacksandjobs.htm#StackManaging). 

2. After creating the stack, click **Terraform Actions**, and select **Plan** from the stack on OCI console UI.

3. Wait for the job to be completed, and review the plan.

    > To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

4. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

5. At this stage your architecture should have been deployed successfully. You can proceed to next section for configuring your Cisco VM Series Firewall.

6. If you no longer require your infrastructure, return to the Stack Details page and **Terraform Actions**, and select **Destroy**.


## Cisco CLI validation

VM_IP_ADDRESS can be obtained from Oracle Cloud console.

```bash
ssh  -i admin-ssh-key admin@VM_IP_ADDRESS
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

Alternatively ```ssh -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa  -i admin-ssh-key admin@${IP_ADDRESS}``` works too.

## Load Balancer

* External load balancer is for outside network
* Internal load balancer is for inside network

### Testing the internal load balancer

The testing client needs to live within *inside-network* VCN. Then a curl test such as `curl http://<private-lb-ip>:<service-port>` can be used for verification.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| mgmt_network | The name of management VCN network | string | VCN-mgmt | no |
| inside_network | The name of inside VCN network | string | VCN-inside | no |
| outside_network | The name of outside VCN network | string | VCN-mgmt | no|
| dmz1_network | The name of dmz1 VCN network | string | VCN-dmz1 | no|
| dmz2_network | The name of dmz2 VCN network | string | VCN-dmz2 | no|
| label_prefix | a string that will be prepended to all resources | string | - | yes |
| num_instances | Number of instances to create | number | 1 | no |
| multiple_ad | Weather instances should be deployed in single or multiple ADs | boolean | - | no |
| vm_compute_shape | The machine type of the instance | string | - | yes |
| mp_listing_resource_id | product version of ftd in OCI market place | string| - | no |
| day_0_config | The zero day configuration file name, under templates folder|string| - | yes |
| admin_ssh_pub_key| ssh public key for admin user | string| - | yes |
| enable_password | enable password for admin user | string| - | no |
| service_port | service  port for application workload | number | 80 | no |
| network_x_name (where x is 1 to 4) | Name assigned to the VCN created | string | - | yes |
| network_x_vcn_cidr (where x is 1 to 4) | CIDR of the VCN created | string | - | yes |
| network_x_subnet_cidr (where x is 1 to 4) | CIDR of the subnet created | string | - | yes |
| network_x_private_ip (where x is 1 to 4) | IP Addresses to be assigned to the instances created | list(string) | - | yes |
| network_x_external_ip (where x is 1 to 4) | If public ip needs to be assigned to the nic in this subnet | boolean | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| networks\_map| The internal networks data structure used|
| networks\_list| The internal networks data structure used|
| vm_external\_ips | The external IPs of the vm instances|
| vm_private\_ips | The private IPs of the vm instances's nic0|
| external\_lb_ip | The IP of external load balancer |
| internal\_lb_ip | The IP of internal load balancer |