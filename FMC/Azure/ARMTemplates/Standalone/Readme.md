# Deploying the Cisco Firepower Management Center
This folder includes an ARM template called <b>fmc.json</b> to deploy an FMC into an existing network.  


There is also a sample parameters file <b>fmc.parameters.json</b> that can be modified as needed, and then used with this template.


## Key features of this template
The ARM template fmc.json has a few distinctions from the marketplace template:  
* You can deploy the FMC into a resource group that already has resources in it.  
* You must specify the private IP address of the FMC.  An ARM template <b>nsg.json</b> is included in this folder.
* The NSG and VNet, along with the management subnet, must already exist.  

## A note on software versions and instance types.

Software versions and supported instance types frequently change. To avoid the need to edit the template, two parameters were created:
* Software Version Other
* VM Size Other

These parameters can be used to override the drop-down lists for Software Display Version and VM Size.<br>
To override a parameter, select <b>Other</b> from the drop-down list. You can run the Azure CLI command:

<b>az vm image list --all --publisher cisco --offer cisco-fmcv -o table</b>

to see the current available versions.<br>
Be sure to check Cisco documentation for supported sizes. Be aware that not all regions support the same sizes.

## Prerequisites
Here are the Azure prerequisites for deploying this resource.
* A VNet with a subnet. This VNet may be in any resource group.
* An NSG to allow SSH and HTTPS access from the appropriate IP addresses.  
<!-- end of the list -->
This folder includes an ARM template for a sample NSG. This NSG allows world inbound SSH and HTTPS traffic. You should limit the source Ip addresses in this NSG for security reasons.

## Workflow
1. Create or select a VNet with at least one subnet. This subnet will be used for management access to the FMC.
2. Create or select an NSG to control access to the FMC.
3. (optional) Create a parameters file.
4. Deploy the ARM template.

## Important information about SSH key (no password) access 
The following is important information if you configure SSH Key authentication for SSH access.  
Because on limitation to Azure Linux deployment:  
* The <b>.ssh</b> directory is placed in the wrong directory.  
* Modifications are made to <b>/etc/ssh/sshd_config</b>, but <b>sshd</b> is not restarted. This is to avoid locking out the users.  
To address these issues:  
A. Log into the FMC via SSH as admin, using the password admin password specified in the template.  
B. Type <b>expert</b>.  
C. Type <b>sudo -i</b>, and enter the admin password when prompted.  
D. Enter the following commands:  
  <b>&nbsp; cp -R /home/*/.ssh/ /Volume/home/admin/  
  &nbsp;  chown -R admin /Volume/home/admin/.ssh  
  &nbsp;  chgrp -R admin /Volume/home/admin/.ssh  
  &nbsp; /etc/rc.d/init.d/sshd restart</b>  
<!-- end of the list -->
You should not exit the FMC until you have confirmed SSH access using the SSH key.  
To revert to password authentication, the line:  
<b>PasswordAuthentication no</b>  
added near the end of <b>/etc/ssh/sshd_config</b>, should be removed and ssnd should be restarted.  
