# Cisco Secure Firewall (FTDv) Multi-VPC Deployment

This Terraform configuration deploys a comprehensive Cisco Secure Firewall architecture with three FTDv instances in a Security VPC, connected to two Spoke VPCs via Transit Gateway for demonstrating east-west traffic flow.

## Architecture Overview

### Network Components

1. **Security VPC (10.0.0.0/16)**
   - Contains 3 Cisco Secure Firewalls (FTDv)
   - Each firewall has 4 subnets:
     - Management (Public)
     - Diagnostic (Private)
     - Outside (Public)
     - Inside (Private)

2. **Spoke VPCs**
   - Spoke-1 VPC (10.1.0.0/16) with Ubuntu instance
   - Spoke-2 VPC (10.2.0.0/16) with Ubuntu instance

3. **Transit Gateway**
   - Connects all VPCs for east-west communication
   - Enables routing between Spoke VPCs through Security VPC

### Firewall Instances

- **Egress-FTDv**: Handles egress traffic to the internet
- **Ingress-FTDv**: Handles ingress traffic from the internet
- **EastWest-FTDv**: Handles east-west traffic between spoke VPCs

### Public IP Assignments

Each firewall receives Elastic IPs on:
- Management interface (for administration)
- Outside interface (for data traffic)

## Prerequisites

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **EC2 Key Pair** created in the target region
4. **Cisco FTDv AMI access** - Ensure you have accepted the license agreement for Cisco FTDv in AWS Marketplace

## Deployment Instructions

### Step 1: Clone and Prepare

```bash
git clone <your-repo>
cd /aws
```

### Step 2: Update Configuration

1. **Update terraform.tfvars**:
   ```hcl
   # Update these values according to your environment
   prefix         = "C15C0"
   aws_region     = "us-east-1"
   key_pair_name  = "your-key-pair-name"  # IMPORTANT: Update this!
   ftdv_password  = "YourSecurePassword123"
   ```

2. **Verify Variables** in `variables.tf` if you need to customize:
   - VPC CIDR blocks
   - Instance types
   - Availability zones

### Step 3: Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### Step 4: Access Your Firewalls

After deployment, use the output values to access your firewalls:

```bash
# Get the output values
terraform output

# Access firewall management interfaces
# https://<firewall-mgmt-public-ip>
# Default credentials: admin / <your-ftdv-password>
```

## Post-Deployment Configuration

### 1. FTDv Initial Setup

For each firewall:
1. Access via HTTPS using the management public IP
2. Login with username `admin` and your configured password
3. Complete initial setup wizard
4. Configure security policies as needed

### 2. Testing East-West Connectivity

Connect to Ubuntu instances via Session Manager or through a bastion host:

```bash
# Test connectivity between spoke VPCs
# From Ubuntu-Spoke1 to Ubuntu-Spoke2
ping <ubuntu-spoke2-private-ip>

# From Ubuntu-Spoke2 to Ubuntu-Spoke1
ping <ubuntu-spoke1-private-ip>
```

## Architecture Diagram

```
                    Internet
                        |
           ┌─────────────────────────────┐
           │                             │
    ┌──────▼──────┐            ┌────────▼────────┐
    │ Egress-FTDv │            │  Ingress-FTDv   │
    │   (AZ-a)    │            │     (AZ-b)      │
    └─────────────┘            └─────────────────┘
           │                             │
           └──────────┐     ┌────────────┘
                      │     │
               ┌──────▼─────▼──────┐
               │   EastWest-FTDv   │
               │      (AZ-a)       │
               └───────────────────┘
                        │
              ┌─────────▼─────────┐
              │  Transit Gateway  │
              └─────────┬─────────┘
                       │
          ┌────────────┼────────────┐
          │            │            │
    ┌─────▼─────┐     │      ┌─────▼─────┐
    │ Spoke-1   │     │      │ Spoke-2   │
    │ VPC       │     │      │ VPC       │
    │ Ubuntu-1  │     │      │ Ubuntu-2  │
    └───────────┘     │      └───────────┘
```

## Resource Naming Convention

All resources are prefixed with the value of `var.prefix` (default: "C15C0"):

- VPCs: `{prefix}-Security-VPC`, `{prefix}-Spoke-1-VPC`, etc.
- Subnets: `{prefix}-Egress-Management-Subnet`, etc.
- Instances: `{prefix}-Egress-FTDv`, `{prefix}-Ubuntu-Spoke1`, etc.
- Security Groups: `{prefix}-FTDv-Management-SG`, etc.

## Outputs

The configuration provides comprehensive outputs including:

- VPC and subnet IDs
- Instance IDs and IP addresses
- Firewall management URLs and SSH commands
- Transit Gateway ID
- Connection information for all resources

## Customization

### Adding More Spokes

To add additional spoke VPCs:

1. Add new VPC variables in `variables.tf`
2. Create VPC and subnet resources in `main.tf`
3. Add Transit Gateway attachment
4. Update route tables
5. Add Ubuntu instance and security group

### Changing Instance Types

Update the following variables:
- `ftdv_instance_type` - For firewall instances
- `ubuntu_instance_type` - For test instances

### Modifying Network Addressing

Update CIDR blocks in `variables.tf`:
- `security_vpc_cidr`
- `spoke1_vpc_cidr` / `spoke2_vpc_cidr`
- Individual subnet CIDRs

## Security Considerations

1. **Key Management**: Ensure your EC2 key pair is securely stored
2. **Password Security**: Use a strong password for FTDv instances
3. **Network Access**: Management interfaces are publicly accessible - consider restricting access
4. **Security Groups**: Default security groups are permissive for lab purposes - restrict for production

## Troubleshooting

### Common Issues

1. **AMI Not Found**: Ensure you've accepted the Cisco FTDv license in AWS Marketplace
2. **Key Pair Error**: Verify the key pair exists in the target region
3. **Instance Launch Failures**: Check instance limits and availability zones
4. **Connectivity Issues**: Verify security groups and routing tables

### Useful Commands

```bash
# Check Terraform state
terraform state list

# Show specific resource
terraform state show aws_instance.egress_ftdv

# Refresh state
terraform refresh

# Destroy infrastructure
terraform destroy
```

## Cost Optimization

- Use smaller instance types for testing (`c5.large` instead of `c5.xlarge`)
- Consider using Spot instances for non-production environments
- Stop instances when not in use
- Use appropriate instance types for your use case

## Support

For issues related to:
- **Terraform configuration**: Check the Terraform documentation
- **AWS resources**: Refer to AWS documentation
- **Cisco FTDv**: Consult Cisco documentation and support

---

**Note**: This is a lab/demo environment. For production use, implement additional security measures, monitoring, and backup strategies.