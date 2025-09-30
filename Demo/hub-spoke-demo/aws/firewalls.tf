# =====================================================
# Data Sources
# =====================================================

data "aws_ami" "ftdv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners      = ["aws-marketplace"]

 filter {
    name   = "name"
    values = ["${var.FTD_version}*"]
  }

  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# =====================================================
# SSH Key Pair Generation
# =====================================================

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.key_pair.private_key_openssh
  filename        = "${var.prefix}-cisco-ftdv-key"
  file_permission = "0700"
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.prefix}-cisco-ftdv-key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# =====================================================
# FTDv Network Interfaces with Specific IP Addresses
# =====================================================

# Egress FTDv Network Interfaces (IP ending in .10)
resource "aws_network_interface" "egress_mgmt" {
  subnet_id         = aws_subnet.management.id
  private_ips       = ["10.0.0.10"]
  security_groups   = [aws_security_group.ftdv_management_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Egress-FTDv-Mgmt-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "egress_diag" {
  subnet_id         = aws_subnet.diagnostic.id
  private_ips       = ["10.0.1.10"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Egress-FTDv-Diag-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "egress_outside" {
  subnet_id         = aws_subnet.outside.id
  private_ips       = ["10.0.2.10"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Egress-FTDv-Outside-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "egress_inside" {
  subnet_id         = aws_subnet.inside.id
  private_ips       = ["10.0.3.10"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Egress-FTDv-Inside-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

# Ingress FTDv Network Interfaces (IP ending in .20)
resource "aws_network_interface" "ingress_mgmt" {
  subnet_id         = aws_subnet.management.id
  private_ips       = ["10.0.0.20"]
  security_groups   = [aws_security_group.ftdv_management_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Ingress-FTDv-Mgmt-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "ingress_diag" {
  subnet_id         = aws_subnet.diagnostic.id
  private_ips       = ["10.0.1.20"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Ingress-FTDv-Diag-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "ingress_outside" {
  subnet_id         = aws_subnet.outside.id
  private_ips       = ["10.0.2.20"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Ingress-FTDv-Outside-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "ingress_inside" {
  subnet_id         = aws_subnet.inside.id
  private_ips       = ["10.0.3.20"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-Ingress-FTDv-Inside-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

# EastWest FTDv Network Interfaces (IP ending in .30)
resource "aws_network_interface" "eastwest_mgmt" {
  subnet_id         = aws_subnet.management.id
  private_ips       = ["10.0.0.30"]
  security_groups   = [aws_security_group.ftdv_management_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-EastWest-FTDv-Mgmt-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "eastwest_diag" {
  subnet_id         = aws_subnet.diagnostic.id
  private_ips       = ["10.0.1.30"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-EastWest-FTDv-Diag-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "eastwest_outside" {
  subnet_id         = aws_subnet.outside.id
  private_ips       = ["10.0.2.30"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-EastWest-FTDv-Outside-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_network_interface" "eastwest_inside" {
  subnet_id         = aws_subnet.inside.id
  private_ips       = ["10.0.3.30"]
  security_groups   = [aws_security_group.ftdv_data_sg.id]
  source_dest_check = false

  tags = {
    Name        = "${var.prefix}-EastWest-FTDv-Inside-ENI"
    Environment = var.environment
    Project     = var.project
  }
}

# =====================================================
# FTDv Instances
# =====================================================

# Egress FTDv Instance
resource "aws_instance" "egress_ftdv" {
  depends_on = [  aws_eip.egress_mgmt_eip, aws_eip.egress_outside_eip ]
  ami           = data.aws_ami.ftdv.id
  instance_type = var.ftdv_instance_type
  key_name      = aws_key_pair.deployer.key_name

  network_interface { 
    network_interface_id = aws_network_interface.egress_mgmt.id 
    device_index = 0
  }

  user_data = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
    admin_password = var.ftdv_password
    hostname      = "Egress-FTDv"
    fmc_ip        = sccfm_ftd_device.engress-fw.hostname
    reg_key       = sccfm_ftd_device.engress-fw.reg_key
    fmc_nat_id    = sccfm_ftd_device.engress-fw.nat_id
  })

  tags = {
    Name        = "${var.prefix}-Egress-FTDv"
    Environment = var.environment
    Project     = var.project
  }
}

# Attach network interfaces to Egress FTDv
resource "aws_network_interface_attachment" "egress_diag_attachment" {
  instance_id          = aws_instance.egress_ftdv.id
  network_interface_id = aws_network_interface.egress_diag.id
  device_index         = 1
}

resource "aws_network_interface_attachment" "egress_outside_attachment" {
  instance_id          = aws_instance.egress_ftdv.id
  network_interface_id = aws_network_interface.egress_outside.id
  device_index         = 2
}

resource "aws_network_interface_attachment" "egress_inside_attachment" {
  instance_id          = aws_instance.egress_ftdv.id
  network_interface_id = aws_network_interface.egress_inside.id
  device_index         = 3
}

# Ingress FTDv Instance
resource "aws_instance" "ingress_ftdv" {
  depends_on = [  aws_eip.ingress_mgmt_eip, aws_eip.ingress_outside_eip ]
  ami           = data.aws_ami.ftdv.id
  instance_type = var.ftdv_instance_type
  key_name      = aws_key_pair.deployer.key_name

  network_interface { 
    network_interface_id = aws_network_interface.ingress_mgmt.id 
    device_index = 0
  }

  user_data = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
    admin_password = var.ftdv_password
    hostname      = "Ingress-FTDv"
    fmc_ip        = sccfm_ftd_device.ingress-fw.hostname
    reg_key       = sccfm_ftd_device.ingress-fw.reg_key
    fmc_nat_id    = sccfm_ftd_device.ingress-fw.nat_id
  })

  tags = {
    Name        = "${var.prefix}-Ingress-FTDv"
    Environment = var.environment
    Project     = var.project
  }
}

# Attach network interfaces to Ingress FTDv
resource "aws_network_interface_attachment" "ingress_diag_attachment" {
  instance_id          = aws_instance.ingress_ftdv.id
  network_interface_id = aws_network_interface.ingress_diag.id
  device_index         = 1
}

resource "aws_network_interface_attachment" "ingress_outside_attachment" {
  instance_id          = aws_instance.ingress_ftdv.id
  network_interface_id = aws_network_interface.ingress_outside.id
  device_index         = 2
}

resource "aws_network_interface_attachment" "ingress_inside_attachment" {
  instance_id          = aws_instance.ingress_ftdv.id
  network_interface_id = aws_network_interface.ingress_inside.id
  device_index         = 3
}

# EastWest FTDv Instance
resource "aws_instance" "eastwest_ftdv" {
  depends_on = [  aws_eip.eastwest_mgmt_eip, aws_eip.eastwest_outside_eip ]
  ami           = data.aws_ami.ftdv.id
  instance_type = var.ftdv_instance_type
  key_name      = aws_key_pair.deployer.key_name

  network_interface { 
    network_interface_id = aws_network_interface.eastwest_mgmt.id 
    device_index = 0
  }

  user_data = templatefile("${path.module}/userdata/ftd_userdata.tftpl", {
    admin_password = var.ftdv_password
    hostname      = "EastWest-FTDv"
    fmc_ip        = sccfm_ftd_device.eastwest-fw.hostname
    reg_key       = sccfm_ftd_device.eastwest-fw.reg_key
    fmc_nat_id    = sccfm_ftd_device.eastwest-fw.nat_id
  })

  tags = {
    Name        = "${var.prefix}-EastWest-FTDv"
    Environment = var.environment
    Project     = var.project
  }
}

# Attach network interfaces to EastWest FTDv
resource "aws_network_interface_attachment" "eastwest_diag_attachment" {
  instance_id          = aws_instance.eastwest_ftdv.id
  network_interface_id = aws_network_interface.eastwest_diag.id
  device_index         = 1
}

resource "aws_network_interface_attachment" "eastwest_outside_attachment" {
  instance_id          = aws_instance.eastwest_ftdv.id
  network_interface_id = aws_network_interface.eastwest_outside.id
  device_index         = 2
}

resource "aws_network_interface_attachment" "eastwest_inside_attachment" {
  instance_id          = aws_instance.eastwest_ftdv.id
  network_interface_id = aws_network_interface.eastwest_inside.id
  device_index         = 3
}

# =====================================================
# Elastic IPs for Management and Outside Interfaces
# =====================================================

# Egress FTDv Elastic IPs
resource "aws_eip" "egress_mgmt_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.egress_mgmt.id
  associate_with_private_ip = aws_network_interface.egress_mgmt.private_ip
  depends_on                = [aws_internet_gateway.security_igw]

  tags = {
    Name        = "${var.prefix}-Egress-FTDv-Mgmt-EIP"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_eip" "egress_outside_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.egress_outside.id
  associate_with_private_ip = aws_network_interface.egress_outside.private_ip
  depends_on                = [aws_internet_gateway.security_igw]

  tags = {
    Name        = "${var.prefix}-Egress-FTDv-Outside-EIP"
    Environment = var.environment
    Project     = var.project
  }
}

# Ingress FTDv Elastic IPs
resource "aws_eip" "ingress_mgmt_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.ingress_mgmt.id
  associate_with_private_ip = aws_network_interface.ingress_mgmt.private_ip
  depends_on                = [aws_internet_gateway.security_igw]

  tags = {
    Name        = "${var.prefix}-Ingress-FTDv-Mgmt-EIP"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_eip" "ingress_outside_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.ingress_outside.id
  associate_with_private_ip = aws_network_interface.ingress_outside.private_ip
  depends_on                = [aws_internet_gateway.security_igw]

  tags = {
    Name        = "${var.prefix}-Ingress-FTDv-Outside-EIP"
    Environment = var.environment
    Project     = var.project
  }
}

# EastWest FTDv Elastic IPs
resource "aws_eip" "eastwest_mgmt_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.eastwest_mgmt.id
  associate_with_private_ip = aws_network_interface.eastwest_mgmt.private_ip
  depends_on                = [aws_internet_gateway.security_igw]

  tags = {
    Name        = "${var.prefix}-EastWest-FTDv-Mgmt-EIP"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_eip" "eastwest_outside_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.eastwest_outside.id
  associate_with_private_ip = aws_network_interface.eastwest_outside.private_ip
  depends_on                = [aws_internet_gateway.security_igw]

  tags = {
    Name        = "${var.prefix}-EastWest-FTDv-Outside-EIP"
    Environment = var.environment
    Project     = var.project
  }
}