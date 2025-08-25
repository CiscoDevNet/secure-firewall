#####################
# Security Groups
#####################

# Allow All
resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.srvc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name} Service SG"
    app  = "service"
  }
}

# Inbound
resource "aws_security_group" "sg_inbound" {
  name        = "VPC Inbound"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.srvc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name} VPC Inbound SG"
    app  = "service"
  }
}

# Outbound
resource "aws_security_group" "sg_outbound" {
  name        = "VPC Outbound"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.srvc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name} VPC Outbound SG"
    app  = "service"
  }
}


# Allow All
resource "aws_security_group" "fmc_ftd_mgmt" {
  name        = "Allow Management Traffic"
  description = "Allow all mgmt traffic"
  vpc_id      = aws_vpc.srvc_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 8305
    to_port     = 8305
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name} Service Mgmt SG"
    app  = "service"
  }
}


resource "aws_security_group" "app_allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name} Service SG"
    app  = "service"
  }
}