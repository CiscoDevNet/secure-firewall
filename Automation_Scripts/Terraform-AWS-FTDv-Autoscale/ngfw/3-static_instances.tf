##################
# Non Autoscaling Instance Provisioning
##################

# FMCv Resources

# FMC AMI
data "aws_ami" "fmcv" {
  count    = var.create_fmcv ? 1 : 0
  most_recent = true
  owners   = ["aws-marketplace"]

 filter {
    name   = "name"
    values = ["fmcv-7.3*"]
  }

  filter {
    name   = "product-code"
    values = ["bhx85r4r91ls2uwl69ajm9v1b"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# FMCv Mgmt Interface
resource "aws_network_interface" "fmc_management" {
  depends_on      = [data.aws_subnet.mgmt_subnet]
  count           = var.create_fmcv ? 1 : 0
  description     = "fmc-mgmt"
  subnet_id       = data.aws_subnet.mgmt_subnet.id
  private_ips     = [var.fmc_mgmt_private_ip]
  security_groups = [data.aws_security_group.allow_all.id]
  tags = {
    Name = "${var.env_name} FMCv Mgmt"
  }
}

# Deploy FMCv Instance in AWS
resource "aws_instance" "fmcv" {
  count               = var.create_fmcv ? 1 : 0
  ami                 = data.aws_ami.fmcv[0].id
  instance_type       = "c5.4xlarge"
  key_name            = aws_key_pair.public_key.key_name
  availability_zone   = var.aws_az
  network_interface {
    network_interface_id = aws_network_interface.fmc_management[0].id
    device_index         = 0
  }
  user_data = <<-EOT
  {
   "AdminPassword":"${var.ftd_pass}",
   "Hostname":"FMCv"
  }
  EOT

  tags = {
    Name = "${var.env_name}_FMCv"
  }
}

# FMC Mgmt Elastic IP
resource "aws_eip" "fmc-mgmt-EIP" {
  depends_on = [data.aws_internet_gateway.mgmt_igw, aws_instance.fmcv]
  count      = var.create_fmcv ? 1 : 0
  tags = {
    "Name" = "${var.env_name} FMCv Management IP"
  }
}


# Assocaite FMC Management Interface to External IP
resource "aws_eip_association" "fmc-mgmt-ip-assocation" {
  count                = var.create_fmcv ? 1 : 0
  network_interface_id = aws_network_interface.fmc_management[0].id
  allocation_id        = aws_eip.fmc-mgmt-EIP[0].id
}


# App Resources

# App AMI
data "aws_ami" "ami_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Instances in App VPC
resource "aws_instance" "app" {
  ami           = data.aws_ami.ami_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.public_key.key_name
  subnet_id     = data.aws_subnet.app_subnet.id
  private_ip    = var.app_server
  associate_public_ip_address = true
  vpc_security_group_ids = [
    data.aws_security_group.app_allow_all.id
  ]
  tags = {
    Name    = "${var.env_name} App Server"
  }
}
