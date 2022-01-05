
## Prerequisites

Make sure you have the following:

- AWS CLI – Learn how to download and set up [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).
- Programmatic access to AWS account with CLI - learn how to set up [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- Optional - if this your first time of using ASAv instances on this account, you have to read and accept the AWS Marketplace terms of the image and subscribe to it first by visiting next link:
https://aws.amazon.com/marketplace/server/procurement?productId=6836725a-4399-455a-bf58-01255e5213b8

The template has been tested on :

- AWS CLI = 2.2.17

## Description

Using this CloudFormation template, one instances of ASA will be deployed in AWS based on the user requirement.

- One new VPC with three or four subnets (1 management network, 2 data networks, 1 optional DMZ network). Or existing VPC with each existing subnets can be used instead.
- Routing table attachment to each of these subnets.
- Public IP attachment to the Management subnet.

### Parameters

| Parameter | Meaning |
| --- | --- |
| `AvailabilityZone` | Availability zone |
| `VpcId = ""` | Existing VPC ID |
| `VpcCidr = "10.0.0.0/16"` | VPC CIDR |
| `IgwId = ""` | Existing Internet Gateway ID |
| `ASA Version = "v9.15.1-15"` | ASA Version |
| `ASA LicType = "BYOL"` | ASA License Type |
| `ASA InstanceType = "c5.xlarge"` | ASA Instance type |
| `ASA Hostname = "cisco ASA"` | Hostname of the ASA |
| `MgmtSubnetId = ""` | Existing Management subnet ID |
| `MgmtSubnetCidr = "10.0.0.0/24"` | Management subnet CIDR |
| `MgmtIp = "0.0.0.0"` | Management interface IP address |
| `InsideSubnetId = ""` | Existing Inside subnet ID |
| `InsideSubnetCidr = "10.0.1.0/24"` | Inside subnet CIDR |
| `InsideIp = "0.0.0.0"` | Inside interface IP address |
| `OutsideSubnetId = ""` | Existing Outside subnet ID |
| `OutsideSubnetCidr = "10.0.2.0/24"` | Outside subnet CIDR |
| `OutsideIp = "0.0.0.0"` | Outside interface IP address |
| `DmzSubnetCidr = "10.0.3.0/24"` | DMZ subnet CIDR |
| `DmzIp = "0.0.0.0"` | DMZ interface IP address |
| `AddDMZInterface = "false"` | Whether or not to add a DMZ interface to ASA |
| `MgmtExternalAccessCidr = "0.0.0.0/0"` | External management access CIDR |
| `KeyName` | The EC2 Key Pair to allow SSH access to ASA |

## Deployment Procedure

1. Clone or Download the Repository
2. Review or change the values in the template file `ASA_Single_Instances_AZ.json`. It might be set during deployment creation.
3. Upload template file to S3
  Go to [S3 console](https://s3.console.aws.amazon.com/s3/home), select your bucket, make folders if needed and click Upload and upload the template file.

  Get the Object URL from the page as show below which is needed in the next step.
4. Head to the [cloudformation console](https://console.aws.amazon.com/cloudformation/home)

5. Create a new stack with new resources

6. Keep the defaults and paste in the S3 object URL copied in the last step.

7. Enter a stack name and proceed to fill in the parameters. The ones needed at minimum are Availability zone and KeyName (used to SSH into the ASA).

8. Hit next, specify any tags if needed and hit next.

9. Review, Acknowledge the below and hit Create Stack to begin the stack initialzation:

>I acknowledge that AWS CloudFormation might require the following capability: CAPABILITY_AUTO_EXPAND
