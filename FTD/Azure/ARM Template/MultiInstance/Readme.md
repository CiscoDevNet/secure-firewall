# Deploying a Load Balance Sandwich with FTD Firewall
This folder includes an ARM template called <b>ftd.sandwitch.json</b> to deploy a load-balanced set of FTD firewall into an existing network. Using this template, you can protect north-south, east-west and outbound traffic.

There is also a sample parameters file <b>ftd.sandwich.parameters.json</b> that can be modified as needed, and then used with this template.


## Use cases
The ARM template covers three use cases:
* Multiple FTD firewalls in a single AZ (load balanced sandwich)
* Multiple FTD firewalls (load balanced sandwich)
* Standalone FTD firewalls (with load balancers for extensibility)

## Key features of this template
The ARM template <b>ftd.json</b> has the following features   
* You can deploy the FTD firewalls into a resource group that already has resources in it.    
* You specify:  
&nbsp; - The number of FTD firewalls in the sandwich<br>
&nbsp; - The number of availability zones to spread the FTD firewalls across. You can enter <b>0</b> for the number of zones to avoid zone assignment.  
* You must specify the frontend private IP address of the internal load balancer (ILB).  
* All private IP addresses on the FTD firewalls are configured dynamically.  
* The management and outside data interfaces are assigned distinct NSGs.  
* The NSGs and VNet, along with four subnets, must already exist.  
* The template only creates and associates public IP addresses for the management interface of each FTD firewall.    
* Both IP forwarding and accelerated networking are enabled, but only on the data interfaces.  

## Availability Zones
One of the parameters in the template specifies the number of Availability Zones.  The firewall instances will be distributed among the Availability Zones using round-robin.
For example, if you select <b>2</b> for the number of Availability Zones and <b>5</b> for the number of firewalls:
* Availability Zone 1 will contain firewall instances 1, 3 and 5.
* Availability Zone 2 will contain firewall instances 2 and 4.

Note that some regions only support two Availability Zones, and some regions do not have Availability Zones.
If you do not want to use availability zones, set the number of Availability Zones to <b>0</b>.

## A note on software versions and instance types.
Software versions and supported instance types frequently change. To avoid the need to edit the template, two parameters were created:
* Software Version Other
* VM Size Other

These parameters can be used to override the drop-down lists for Software Display Version and VM Size.<br>
To override a parameter, select <b>Other</b> from the drop-down list. You can run the Azure CLI command:

<b>az vm image list --all --publisher cisco --offer cisco-ftdv -o table</b>

to see the current available versions.<br>
Be sure to check Cisco documentation for supported sizes. Be aware that not all regions support the same sizes.

## Resources created by the template
This template creates the following resources. Here the number <i>N</i> represents the number of FTD firewalls
* Two load balancers  
&nbsp; - A public load balancer with TCP port 22 probe and two sample load-balancing rules: HTTP and HTTPS  
&nbsp; - An internal load balancer with TCP port 22 probe and one <i>HA Port</i> load-balancing rule to load balance all ports and protocols  
* <i>N+1</i> public IP addresses  
&nbsp; - One for the public load balancer   
&nbsp; - One for the management interface of each FTD firewall  
* <i>4N</i> network interfaces: four for each firewall  
* <i>N</i> storage accounts: one for each firewall  
* <i>N</i> disks: one for each firewall  
* <i>N</i> FTD firewall virtual machines  


## Sample deployment
<img src="https://github.com/CiscoDevNet/Cisco-FTD-PublicCloud/blob/main/Azure/LoadBalanced/Sandwich.jpg" alt="FTD standalone" style="max-width:50%;">
In this deployment the service VNet is the hub of a hub-and-spoke datacenter topology. Only one spoke is shown in the figure. Each spoke uses VNet peering to communicate to the service VNet. An Azure route table must be deployed to handle north-south return traffic, as well as east-west and outbound traffic. This route table must be associated with every subnet in the spoke. The following is a typical route table:  
<img src="https://github.com/CiscoDevNet/Cisco-FTD-PublicCloud/blob/main/Azure/Standalone/RouteTable.png" alt="Route Table" style="max-width:50%;">
Here the inside internal load balancer has frontend IP address <b>10.100.100.81</b> and the route table is associated with three subnets in the spoke. The spoke VNet CIDR is <b>10.101.0.0/16</b>. Note that you need two routes: the default route for north-south and outbound traffic (and inter-spoke traffic, if other spokes exist), and an additional route for intra-spoke east-west traffic within the spoke VNet.  Without the additional route the intra-spoke east-west traffic will bypass the FTD firewall do to effective (implicit) Azure routing.


The routing table above is for a single spoke.  If there are additional spokes or on-premise traffic that needs inspection, additional routes must be added.

## Prerequisites
Here are the Azure prerequisites for deploying this resource.
* A VNet with four subnets. This VNet may be in any resource group.  The subnets correspond to the four interfaces on the FTD firewall:  
&nbsp; - (Nic0) Management: used for SSH access and FMC access to the FTD firewall  
&nbsp; - (Nic1) Diagnostic: typically not used, but can be used for SNMP or Syslog  
&nbsp; - (Nic2) Outside: used as the ingress and egress the Internet  
&nbsp; - (Nic3) Inside: used for access to and from internal servers  
* An NSG to allow inbound access to the management interface from the FMC on TCP port 8305 and SSH access from the appropriate IP addresses  
* An NSG to allow inbound access to the outside interface for the ports and protocols you wish to expose.  
<!-- end of the list -->
This folder includes ARM templates for two sample NSGs. 
* An NSG to allow TCP port 8305 and SSH inbound access. This can be associated to the management interface when deploying the template. You should limit the source IP addresses in this NSG for security reasons.
* An NSG to allow HTTP and HTTPS inbound access. This can be associated to the outbound interface when deploying the template. You should modify this list of services as is appropriate for the targets of the north-south traffic

## Workflow
1. Create or select a VNet with at least four subnet. 
2. Create or select an NSG to control management access to the FTD firewall.
3. Create or select an NSG to control north-south access to the FTD firewall.
4. (optional) Create a parameters file.
5. Deploy the ARM template.

## Important information about SSH key (no password) access 
The following is important information if you configure SSH Key authentication for SSH access.  
Because on limitation to Azure Linux deployment:  
* The <b>.ssh</b> directory is placed in the alternative user's home directory (altUser), but not the admin user's home directory.  
* Modifications are made to <b>/etc/ssh/sshd_config</b> that disable password authentication, so the admin user has no way to SSH to the FTD firewall.  
To address these issues:  
A. Log into the FTD via SSH as the alternative user, using the private key corresponding to the public key entered into the template.  
B. Type <b>su - admin</b>. When prompted, enter the admin password for the FTD firewall.
C. Type <b>expert</b>, and enter the admin password when prompted.   
D. Type <b>sudo -i</b>, and enter the admin password when prompted.  
E. Enter the following commands:  
  <b>&nbsp; cp -R /home/*/.ssh/ /home/admin/  
  &nbsp;  chown -R admin /home/admin/.ssh  
  &nbsp;  chgrp -R admin /home/admin/.ssh  
<!-- end of the list -->
You should not exit the FTD firewall until you have confirmed SSH admin access using the SSH key.  
To revert to password authentication, the line:  
<b>PasswordAuthentication no</b>  
added near the end of <b>/etc/ssh/sshd_config</b>, should be removed and ssHd should be restarted:  
  <b>/etc/rc.d/init.d/sshd restart</b>


