## AWS Gateway Loadbalancer with Cisco Secure Firewall setup

This section contains sample Terraform templates to setup a Gateway Loadbalancer architecture on AWS with Cisco Secure Firewalls as target.

### **GWLB**

[Template to setup Gateway Loadbalaner and associated resources](GWLB)

<img src="images/GWLB.png" width="600" height="500">

### **GWLB Centralized Architecture**

To set up a centralized inspection architecture with AWS GWLB and Cisco Secure Firewall, deploy the GWLB template above and then deploy the following template.
[Template to setup a centralized architecture for GWLB](centralized_architecture)

<img src="images/centralized_architecture.png" width="800" height="500">
