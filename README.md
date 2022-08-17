# Secure-Firewall

## Templates & Automation Resources
The `secure-firewall` repository provides a collection of Templates and Automation Resources to get you started with  Cisco Secure Firewall on diverse cloud platforms like AWS, Azure, others.

Please visit our latest cloud resources [website on developer.cisco.com](https://developer.cisco.com/secure-firewall/cloud-resources/) where additional videos and learning materials are uploaded.

Repos are organized per: **Product** >> **Cloud Platform** >>  **Infrastructure as Code (IaC)** >> **Use Case**

Each specific usecase contains a README file with installation instructions.

## Index
* **ASA on AWS:**
  * _CloudFormation templates:_
     * [Multiple ASA instances in multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/CloudFormation/ASA_Multiple_Instance_MultiAz)
     * [Multiple ASA instances in a single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/CloudFormation/ASA_Multiple_Instance_SingleAZ)
     * [Single ASA Instance in a single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/CloudFormation/ASA_Single_Instance)
     * [_ASAv Autoscale_](https://github.com/CiscoDevNet/cisco-asav/tree/master/autoscale/aws)
  * _Terraform templates:_
     * [Multiple ASA instances in multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/Terraform/ASA_A_A_Multiple_AZ)
     * [Multiple ASA instances in a single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/Terraform/ASA_A_A_Single_AZ)
     * [Single ASA instance in a AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/AWS/Terraform/ASA_Single_Instances_AZ)
  
* **ASA on Azure:**
  * _ARM Templates:_
     * [Multiple ASA instances](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/Azure/ARM%20Template/Deployment)
     * [Single ASA instance in single location](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/Azure/ARM%20Template/Deployment)
     * [_ASAv Autoscale_](https://github.com/CiscoDevNet/cisco-asav/tree/master/autoscale/azure)
  * _Terraform templates:_
     * [Single ASA instance in single location](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/Azure/Terraform/Single%20Instance)
     * [Multi Instances in Multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/Azure/Terraform/MultiInstanceMultiAZ)
     * [Multi Instances in Multiple AZ using existing subnets](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/Azure/Terraform/MultiInstanceMultiAZ_ExistingSubnets) 

* **ASA on GCP:**
  * _Terraform templates:_
    * [Single ASA instance in single location](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/GCP/Terraform/Deployment/examples/single-instance)
    * [Multiple ASA Instances in Single or Multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/GCP/Terraform/Deployment/examples/multi-instances)
  * _Deployment Manager templates:_
    * [ASA Deployments](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/GCP/Deployment-Manager/examples) 

* **ASA on OCI:**
  * _Terraform templates:_
    * [Single ASA Instance](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/OCI/Terraform/examples/single-instance)
    * [Multiple ASA Instances](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/OCI/Terraform/examples/ha)
  * _Oracle Resource Manager:_
    * [ASA Deployment](https://github.com/CiscoDevNet/secure-firewall/tree/main/ASA/OCI/Resource_Manager) 

* **FTD on AWS:**
  * _CloudFormation templates:_
     * [Multiple FTD instances in multiple AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/CloudFormation/FTD_MultipleInstance_MultiAZ)
     * [Multiple FTD instances in a single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/CloudFormation/FTD_MultipleInstance_SingleAZ)
     * [Single Instance of FTD with FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/CloudFormation/FTD_FMC_SingleInstance)
     * [_FTDv Autoscale_](https://github.com/CiscoDevNet/cisco-ftdv/tree/master/autoscale/aws)
  * _Terraform templates:_
     * [Deployment of Active/Active FTDv(stateless) with NLB in Two different AZ with FMCv](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_FMC_A_A_Multiple_AZ)
     * [Active/Active FTDv(stateless) with NLB and FMCv in a Single AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_FMC_A_A_Single_AZ)
     * [FTDv and FMCv in single instances in a AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_FMC_Single_Instance_in_AZ)
     * [FTDv single instance in an Availability Zone (AZ)](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/FTD_Single_Instance_AZ)
     * [Gateway Loadbalancer Setup](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/AWS/Terraform/GatewayLoadbalancer)
       * Centralized Architecture
      * [AWS Lab to deploy FTDv and FMC using IaC](https://catalog.us-east-1.prod.workshops.aws/workshops/38565e8c-3a5f-4e93-8412-5fdec23744ca/en-US)
        * Lab to programmatically deploy FTDv and FMC using Infrastructure as Code (Terraform)

* **FTD on Azure:**
  * _ARM templates:_
     * [Multiple FTD instances in AZ](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/ARM%20Template/MultiInstance)
     * [Single FTD instance](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/ARM%20Template/Standalone) 
     * [_FTDv Autoscale_](https://github.com/CiscoDevNet/cisco-ftdv/tree/master/autoscale/azure)
  * _Terraform templates:_
     * [Single FTDv Instance](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/Terraform/SingleInstance)
     * [Single FTDv Instance in Existing Resouce Group](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/Terraform/SingleInstance_ExistingRG)
     * [Multiple FTDv Instances in Multiple Availablility Zones](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/Terraform/MultiInstance_MultiAZ)
     * [Multiple FTDv Instances in Multiple Availability Zones using Existing Subnets](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Azure/Terraform/MultiInstance_MultiAZ_ExistingSubnet)

* **FTD on GCP:**
  * _Terraform templates:_
    * [Single FTD Instance](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/GCP/Terraform/examples/single-instance)
  * _Deployment Manager Templates:_
    * [Single FTDv instance](https://github.com/CiscoDevNet/secure-firewall/blob/main/FTD/GCP/Deployment_Manager/examples/single-instance.yaml)

* **FTD on OCI:**
  * _Terraform templates:_
    * [Single FTD Instance](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/OCI/Terraform/examples/single-instance)
  * _Oracle Resource Manager:_
    * [FTD Deployment](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/OCI/Resource_Manager)

* **FTD Ansible Modules**
  * [FTD Ansible Github](https://github.com/CiscoDevNet/FTDAnsible)
  * [FTD Ansible Documentation](https://developer.cisco.com/site/ftd-ansible/)

* **FTD on Vmware:**
  * _Terraform Templates:_
    * [Single Instance FTD](https://github.com/CiscoDevNet/secure-firewall/tree/main/FTD/Vmware/Terraform)

* **FMC Terraform Provider:**
  * [FMC Terraform Provider Github](https://github.com/CiscoDevNet/terraform-provider-fmc)
  * [FMC Terraform Registry](https://registry.terraform.io/providers/CiscoDevNet/fmc/latest)
  
* **FMC Ansible Collection:**
  * [An Ansible collection for managing FMC](https://galaxy.ansible.com/cisco/fmcansible)

* **FMC on Azure:**
  * _Terraform templates:_
    * [Standalone FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/Azure/Terraform/standalone)
  * _ARM Templates:_
    * [Standalone FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/Azure/ARMTemplates/Standalone)

* **FMC on AWS:**
  * _Terraform templates:_
    * [Standalone FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/AWS/Standalone)

* **FMC on Vmware:**
  * _Terraform templates:_
    * [Standalone FMC](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/Vmware/Terraform)

* **FMC on GCP:**
  * _Terraform templates:_
    * [FMC Deployment in New or Existing newtwork](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/GCP/Terraform/examples/single-instance)
  * _Resource Manager Templates:_
    * [FMC Deployment in New or Existing newtwork](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/GCP/Deployment_Manager)

* **FMC on OCI:**
  * _Terraform templates:_
    * [FMC Deployment in New or Existing newtwork](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/OCI/Terraform)
  * _Deployment Manager templates:_
    * [FMC Deployment in New or Existing newtwork](https://github.com/CiscoDevNet/secure-firewall/tree/main/FMC/OCI/Resource_Manager/resource-manager)

 * **Cloud Native:**
   * [SFCN GitHub Repository](https://github.com/CiscoDevNet/sfcn)
 
 * **CSDAC - Cisco Secure Dynamic Attributes Connector:**
   * [CSDAC Ansible](https://galaxy.ansible.com/cisco/csdac)

 * **Automation Scripts:**
   * [Retrieve Access Rules hit counts and rule usage](https://github.com/CiscoDevNet/secure-firewall/tree/main/Automation_Scripts/FMC_AccessRule_HitCount)
   * [Decomission access rules](https://github.com/CiscoDevNet/secure-firewall/tree/main/Automation_Scripts/decomission_AccessRules)

## Disclaimer
These repositories should be used only as a **proof of concept**. It is your duty to secure the provisioned device's by following cloud provider and product based security best practices guidelines.
