module "service_network" {
  source                = "CiscoDevNet/secure-firewall/aws//modules/network"
  vpc_name             = var.service_vpc_name
  create_igw           = var.service_create_igw
  igw_name             = var.service_igw_name
  mgmt_subnet_cidr     = var.mgmt_subnet_cidr
  outside_subnet_cidr  = var.outside_subnet_cidr
  diag_subnet_cidr     = var.diag_subnet_cidr
  inside_subnet_cidr   = var.inside_subnet_cidr
  fmc_ip               = var.fmc_ip
  mgmt_subnet_name     = var.mgmt_subnet_name
  outside_subnet_name  = var.outside_subnet_name
  diag_subnet_name     = var.diag_subnet_name
  inside_subnet_name   = var.inside_subnet_name
  outside_interface_sg = var.outside_interface_sg
  inside_interface_sg  = var.inside_interface_sg
  mgmt_interface_sg    = var.mgmt_interface_sg
  use_ftd_eip          = var.use_ftd_eip
}

module "spoke_network" {
  source              = "CiscoDevNet/secure-firewall/aws//modules/network"
  vpc_name            = var.spoke_vpc_name
  vpc_cidr            = var.spoke_vpc_cidr
  create_igw          = var.spoke_create_igw
  igw_name            = var.spoke_igw_name
  outside_subnet_cidr = var.spoke_subnet_cidr
  outside_subnet_name = var.spoke_subnet_name
}

module "instance" {
  source                  = "../modules/FirewallServer/"
  ftd_version             = var.ftd_version
  keyname                 = var.keyname
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  fmc_mgmt_ip             = var.fmc_ip
  ftd_mgmt_interface      = module.service_network.mgmt_interface
  ftd_inside_interface    = module.service_network.inside_interface
  ftd_outside_interface   = module.service_network.outside_interface
  ftd_diag_interface      = module.service_network.diag_interface
  fmc_nat_id              = var.fmc_nat_id
}

module "gwlb" {
  source      = "CiscoDevNet/secure-firewall/aws//modules/gwlb"
  gwlb_name   = var.gwlb_name
  gwlb_subnet = module.service_network.outside_subnet
  gwlb_vpc_id = module.service_network.vpc_id
  instance_ip = module.service_network.outside_interface_ip
}

module "gwlbe" {
  source            = "CiscoDevNet/secure-firewall/aws//modules/gwlbe"
  gwlbe_subnet_cidr = var.gwlbe_subnet_cidr
  gwlbe_subnet_name = var.gwlbe_subnet_name
  vpc_id            = module.service_network.vpc_id
  ngw_id            = module.nat_gw.ngw
  gwlb              = module.gwlb.gwlb
  spoke_subnet      = module.spoke_network.outside_subnet
}

module "nat_gw" {
  source                  = "CiscoDevNet/secure-firewall/aws//modules/nat_gw"
  ngw_subnet_cidr         = var.ngw_subnet_cidr
  ngw_subnet_name         = var.ngw_subnet_name
  availability_zone_count = var.availability_zone_count
  vpc_id                  = module.service_network.vpc_id
  internet_gateway        = module.service_network.internet_gateway[0]
  spoke_subnet_cidr       = module.spoke_network.outside_subnet_cidr
  gwlb_endpoint_id        = module.gwlbe.gwlb_endpoint_id
  is_cdfmc                = var.is_cdfmc
  mgmt_rt_id              = module.service_network.mgmt_rt_id
}

module "transitgateway" {
  source                      = "CiscoDevNet/secure-firewall/aws//modules/transitgateway"
  create_tgw                  = var.create_tgw
  vpc_service_id              = module.service_network.vpc_id
  vpc_spoke_id                = module.spoke_network.vpc_id
  tgw_subnet_cidr             = var.tgw_subnet_cidr
  tgw_subnet_name             = var.tgw_subnet_name
  vpc_spoke_cidr              = module.spoke_network.vpc_cidr
  spoke_subnet_id             = module.spoke_network.outside_subnet
  spoke_rt_id                 = module.spoke_network.outside_rt_id
  gwlbe                       = module.gwlbe.gwlb_endpoint_id
  transit_gateway_name        = var.transit_gateway_name
  availability_zone_count     = var.availability_zone_count
  nat_subnet_routetable_ids   = module.nat_gw.nat_rt_id
  gwlbe_subnet_routetable_ids = module.gwlbe.gwlbe_rt_id
}

#--------------------------------------------------------------------

#the code waits for 720 seconds for the resources above to be deployed and running
resource "time_sleep" "wait_600_seconds" {
  depends_on = [
    module.instance
  ]
  create_duration = "720s"
}

resource "aws_subnet" "lambda" {
  vpc_id     = module.service_network.vpc_id
  cidr_block = var.lambda_subnet_cidr

  tags = {
    Name = var.lambda_subnet_name
  }
}

# resource "aws_route_table" "lambda_route" {
#   vpc_id = module.service_network.vpc_id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = module.nat_gw.ngw[0]
#   }

#   tags = {
#     Name = "Lambda Routing table"
#   }
# }

# resource "aws_route_table_association" "lambda_association" {
#   subnet_id      = aws_subnet.lambda.id
#   route_table_id = aws_route_table.lambda_route.id
# }

resource "aws_security_group" "sg_for_lambda" {
  name   = "lambda_sg"
  vpc_id = module.service_network.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "../static_files/autoscale_layer.zip"
  layer_name = "fmc_config_layer"

  compatible_runtimes = ["python3.9"]
}

resource "aws_iam_role" "lambda_role" {
name   = "gwlb_lambda_role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "gwlb_aws_iam_policy_for_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   },
   {
      "Effect": "Allow",
      "Action": [
          "ec2:CreateNetworkInterface",
          "sts:AssumeRole",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
      ],
      "Resource": "*"
    }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_lambda_function" "lambda" {
  filename      = "../static_files/fmc_latest.py.zip"
  function_name = var.lambda_func_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "fmc_latest.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.lambda_layer.arn]
  timeout       = 800
  vpc_config {
    subnet_ids         = [aws_subnet.lambda.id]
    security_group_ids = [aws_security_group.sg_for_lambda.id]
  }

  environment {
    variables = {
      ADDR         = var.fmc_ip,
      USERNAME     = var.fmc_username,
      PASSWORD     = var.fmc_password,
      FTD1         = module.service_network.mgmt_interface_ip[0],
      FTD2         = module.service_network.mgmt_interface_ip[1],
      gw1          = var.ftd_inside_gw[0],
      gw2          = var.ftd_inside_gw[1],
      IS_CDFMC     = var.is_cdfmc,
      DOMAIN_UUID  = var.domainUUID
      ACCESS_TOKEN = var.token
    }
  }
}

resource "aws_lambda_invocation" "aws_lambda_invoke" {
  depends_on = [
    aws_lambda_function.lambda,
    time_sleep.wait_600_seconds
  ]

  function_name = aws_lambda_function.lambda.function_name

  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
  })
}