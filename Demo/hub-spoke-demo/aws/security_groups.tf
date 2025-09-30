# =====================================================
# Security Groups
# =====================================================

# Security Group for FTDv Management
resource "aws_security_group" "ftdv_management_sg" {
  name_prefix = "${var.prefix}-ftdv-mgmt-"
  vpc_id      = aws_vpc.security_vpc.id
  description = "Security group for FTDv Management interfaces"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All inbound traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "${var.prefix}-FTDv-Management-SG"
    Environment = var.environment
    Project     = var.project
  }
}

# Security Group for FTDv Data interfaces
resource "aws_security_group" "ftdv_data_sg" {
  name_prefix = "${var.prefix}-ftdv-data-"
  vpc_id      = aws_vpc.security_vpc.id
  description = "Security group for FTDv Data interfaces"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All inbound traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "${var.prefix}-FTDv-Data-SG"
    Environment = var.environment
    Project     = var.project
  }
}

# Security Group for Ubuntu instances
resource "aws_security_group" "ubuntu_sg" {
  name_prefix = "${var.prefix}-ubuntu-"
  vpc_id      = aws_vpc.spoke1_vpc.id
  description = "Security group for Ubuntu instances"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All inbound traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "${var.prefix}-Ubuntu-SG"
    Environment = var.environment
    Project     = var.project
  }
}

# Security Group for Ubuntu instances in Spoke-2
resource "aws_security_group" "ubuntu_spoke2_sg" {
  name_prefix = "${var.prefix}-ubuntu-spoke2-"
  vpc_id      = aws_vpc.spoke2_vpc.id
  description = "Security group for Ubuntu instances in Spoke-2"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All inbound traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "${var.prefix}-Ubuntu-Spoke2-SG"
    Environment = var.environment
    Project     = var.project
  }
}