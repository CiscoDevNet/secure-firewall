# Azure Virtual WAN + Cisco FTDv Security Architecture

This directory contains Terraform configuration for deploying a sophisticated network security architecture in Microsoft Azure, replicating the AWS Transit Gateway + FTDv deployment in Azure using Virtual WAN.

## Architecture Overview

### Core Components
- **Azure Virtual WAN Hub**: Centralized routing and connectivity hub
- **Security VNet**: Dedicated virtual network hosting 3 Cisco FTDv firewalls
- **Spoke VNets**: Two spoke networks (Spoke1: 172.0.0.0/16, Spoke2: 192.0.0.0/16)
- **Centralized Security Inspection**: All traffic routed through FTDv firewalls

### Network Design
```
                    ┌─────────────────┐
                    │   Virtual WAN   │
                    │      Hub        │
                    │   10.1.0.0/24   │
                    └─────────┬───────┘
                              │
            ┌─────────────────┼─────────────────┐
            │                 │                 │
    ┌───────▼──────┐ ┌───────▼──────┐ ┌───────▼──────┐
    │  Security    │ │   Spoke1     │ │   Spoke2     │
    │    VNet      │ │    VNet      │ │    VNet      │
    │ 10.0.0.0/16  │ │172.0.0.0/16  │ │192.0.0.0/16  │
    └──────────────┘ └──────────────┘ └──────────────┘
```

## Security VNet Subnets
- **Management**: 10.0.1.0/24 (FTDv management interfaces)
- **Diagnostic**: 10.0.2.0/24 (FTDv diagnostic interfaces)
- **Outside**: 10.0.3.0/24 (FTDv untrust/outside interfaces)
- **Inside**: 10.0.4.0/24 (FTDv trust/inside interfaces)

## FTDv Firewall Deployment
- **3 Specialized FTDv Instances**:
  - Egress Firewall: Outbound internet traffic inspection
  - Ingress Firewall: Inbound traffic inspection
  - East-West Firewall: Inter-spoke traffic inspection

### FTDv IP Assignments
```
Firewall Role | Management  | Diagnostic | Outside    | Inside
------------- | ----------- | ---------- | ---------- | ----------
Egress        | 10.0.1.10   | 10.0.2.10  | 10.0.3.10  | 10.0.4.10
Ingress       | 10.0.1.11   | 10.0.2.11  | 10.0.3.11  | 10.0.4.11
East-West     | 10.0.1.12   | 10.0.2.12  | 10.0.3.12  | 10.0.4.12
```

## Traffic Flow Design
1. **Spoke-to-Spoke**: Traffic routed through East-West FTDv for inspection
2. **Spoke-to-Internet**: Traffic routed through Egress FTDv for inspection
3. **Internet-to-Spoke**: Traffic routed through Ingress FTDv for inspection
4. **Return Traffic**: Proper return path routing via static routes

## Files Structure

### Core Infrastructure
- `provider.tf` - Azure and FMC provider configuration
- `variables.tf` - All variable definitions with default values
- `terraform.tfvars.example` - Example values file
- `resource_groups.tf` - Resource group definitions

### Network Infrastructure
- `virtual_wan.tf` - Virtual WAN hub and custom route tables
- `security_vnet.tf` - Security VNet with subnets and NSGs
- `spoke_vnets.tf` - Spoke VNets with test VMs

### Security Infrastructure
- `ftdv_firewalls.tf` - FTDv firewall VM deployments
- `fmc_config.tf` - FMC policies and device configuration

### Outputs
- `outputs.tf` - Deployment outputs and key information

## Configuration Variables

### Core Variables
- `resource_prefix`: Prefix for all Azure resources (default: "C15C0")
  - Helps organize resources and avoid naming conflicts
  - Applied to all resource names: resource groups, VNets, VMs, etc.

### Example Configuration
```hcl
# terraform.tfvars
resource_prefix = "C15C0"
admin_password = "your-secure-password"
fmc_ip = "10.0.1.100"
```

## Prerequisites

1. **Azure Subscription** with sufficient permissions
2. **Cisco Security Cloud (SCC) Account** with FMC access
3. **Azure CLI** configured with appropriate credentials
4. **Terraform** v1.0+ with Azure provider

## Deployment Steps

1. **Configure Variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan Deployment**:
   ```bash
   terraform plan
   ```

4. **Deploy Infrastructure**:
   ```bash
   terraform apply
   ```

## Required Variables

### Cisco Security Cloud
- `scc_token` - API token for SCC
- `cdfmc_host` - FMC hostname

### Authentication
- `ftdv_admin_password` - Password for FTDv instances
- `admin_password` - Password for test VMs

## Network Configuration

### Default CIDR Blocks
- Security VNet: `10.0.0.0/16`
- Spoke1 VNet: `172.0.0.0/16` 
- Spoke2 VNet: `192.0.0.0/16`
- Virtual WAN Hub: `10.1.0.0/24`

### Route Tables
- **Security Route Table**: Default route for all traffic inspection
- **Spoke1 Route Table**: Routes Spoke1 traffic through security inspection
- **Spoke2 Route Table**: Routes Spoke2 traffic through security inspection

## Multi-Cloud Integration

This Azure deployment mirrors the AWS Transit Gateway architecture:
- **AWS**: Transit Gateway + Security VPC + Spoke VPCs
- **Azure**: Virtual WAN Hub + Security VNet + Spoke VNets
- **Unified Security**: Same FMC policies across both clouds

## Testing and Validation

### Test VMs
- **Spoke1 VM**: Ubuntu 20.04 with networking tools
- **Spoke2 VM**: Ubuntu 20.04 with networking tools
- **Public IPs**: For SSH access and testing
- **Private IPs**: For internal connectivity testing

### Connectivity Tests
1. SSH to test VMs via public IPs
2. Test inter-spoke connectivity through firewalls
3. Validate internet access through security inspection
4. Monitor FMC for traffic logs and policies

## Security Features

### Network Security Groups
- **Management**: SSH, HTTPS, FMC registration ports
- **Outside**: Controlled internet access
- **Inside**: Spoke network access
- **Spoke Subnets**: Standard web and SSH access

### Firewall Inspection
- All inter-spoke traffic inspected
- Internet egress inspection
- Internet ingress inspection
- Centralized security policies

## Troubleshooting

### Common Issues
1. **FTDv Registration**: Check SCC token and FMC connectivity
2. **Routing**: Verify Virtual WAN route table associations
3. **NSG Rules**: Ensure proper security group configurations
4. **IP Forwarding**: Verify enabled on FTDv interfaces

### Validation Commands
```bash
# Check Virtual WAN hub status
az network vhub show --name vhub-dev --resource-group rg-virtualwan-dev

# Check route tables
az network vhub route-table show --vhub-name vhub-dev --name rt-security --resource-group rg-virtualwan-dev

# Test VM connectivity
ssh azureuser@<spoke1-public-ip>
ping <spoke2-private-ip>
```

## Cost Optimization

### VM Sizing
- FTDv: `Standard_D4s_v3` (4 vCPU, 16GB RAM)
- Test VMs: `Standard_B2s` (2 vCPU, 4GB RAM)

### Storage
- Premium SSD for FTDv (better performance)
- Standard SSD acceptable for test VMs

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete all deployed infrastructure.

## Architecture Benefits

1. **Centralized Security**: All traffic inspected through dedicated security layer
2. **Scalability**: Easy addition of new spoke VNets
3. **Multi-Cloud**: Unified security policies across AWS and Azure
4. **Flexibility**: Different firewall instances for different traffic types
5. **Monitoring**: Centralized logging and policy management through FMC

## Next Steps

1. **Device Registration**: Register FTDv devices with FMC
2. **Policy Configuration**: Configure detailed security policies
3. **Monitoring Setup**: Configure logging and alerting
4. **Performance Tuning**: Optimize based on traffic patterns
5. **Multi-Cloud Integration**: Connect with AWS deployment for hybrid scenarios