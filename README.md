# Secure-Firewall

## Templates & Automation Resources
The `secure-firewall` repository provides a collection of Templates and Automation Resources to get you started with  Cisco Secure Firewall on diverse cloud platforms like AWS, Azure, others.

Repos are organized per: **Product** >> **Cloud Platform** >>  **Infrastructure as Code (IaC)** >> **Use Case**

Each specific usecase contains a README file with installation instructions.

## Index
* **ASA on AWS:**
  * _CloudFormation templates:_
     * [Multiple ASA instances in multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/CloudFormation/ASA_Multiple_Instance_MultiAz)
     * [Multiple ASA instances in a single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/CloudFormation/ASA_Multiple_Instance_SingleAZ)
  * _Terraform templates:_
     * [Multiple ASA instances in multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/Terraform/ASA_A_A_Multiple_AZ)
     * [Multiple ASA instances in a single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/Terraform/ASA_A_A_Single_AZ)
     * [Single ASA instance in a AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/Terraform/ASA_Single_Instances_AZ)
* **ASA on Azure:**
  * _ARM Templates:_
     * [Templates coming soon...](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/Azure/ARM%20Template)
  * _Terraform templates:_
     * [Single ASA instance in single location](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/Azure/Terraform/Single%20Instance)
* **FTD on AWS:**
  * _CloudFormation templates:_
     * [Multiple FTD instances in multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/CloudFormation/FTD_MultipleInstance_MultiAZ)
     * [Multiple FTD instances in a single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/CloudFormation/FTD_MultipleInstance_SingleAZ)
  * _Terraform templates:_
     * [Deployment of Active/Active FTDv(stateless) with NLB in Two different AZ with FMCv](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_FMC_A_A_Multiple_AZ)
     * [Active/Active FTDv(stateless) with NLB and FMCv in a Single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_FMC_A_A_Single_AZ)
     * [FTDv and FMCv in single instances in a AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_FMC_Single_Instance_in_AZ)
     * [FTDv single instance in an Availability Zone (AZ)](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_Single_Instance_AZ)
* **FTD on Azure:**
  * _ARM templates:_
     * [Template coming soon...](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/ARM%20Template) 
  * _Terraform templates:_
     * [Template coming soon...](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/Terraform)
* **FTD Ansible Modules**
  * [FTD Ansible Github](https://github.com/CiscoDevNet/FTDAnsible)
  * [FTD Ansible Documentation](https://developer.cisco.com/site/ftd-ansible/)
* **FTD on Vmware:**
  * _Terraform Templates:_
    * Standalone FTD
* **FMC Terraform Provider:**
  * [FMC Terraform Provider Github](https://github.com/CiscoDevNet/terraform-provider-fmc)
  * [FMC Terraform Registry](https://registry.terraform.io/providers/CiscoDevNet/fmc/latest)
* **FMC on Azure:**
  * _Terraform templates:_
    * [Standalone FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/Azure/Standalone)
* **FMC on AWS:**
  * _Terraform templates:_
    * [Standalone FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/AWS/Standalone)
* **FMC on Vmware:**
  * _Terraform templates:_
    * [Standalone FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/Vmware/Terraform)
 * **Cloud Native:**
   * [SFCN GitHub Repository](https://github.com/CiscoDevNet/sfcn)
 * **CSDAC - Cisco Secure Dynamic Attributes Connector:**
   * [CSDAC Ansible](https://galaxy.ansible.com/cisco/csdac)

## Disclaimer
These repositories should be used only as a **proof of concept**. It is your duty to secure the provisioned device's by following cloud provider and product based security best practices guidelines.
