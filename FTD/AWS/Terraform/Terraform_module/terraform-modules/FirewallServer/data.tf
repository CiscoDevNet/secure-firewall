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

data "template_file" "ftd_startup_file" {
    count = var.instances_per_az * var.availability_zone_count
    template = file("${path.module}/ftd_startup_file.txt")
    vars = {
    fmc_ip       = var.fmc_mgmt_ip
    fmc_nat_id   = var.fmc_nat_id
    reg_key      = var.reg_key
    }
}

data "aws_ami" "fmcv" {
  #most_recent = true      // you can enable this if you want to deploy more
  count       = var.create_fmc ? 1 : 0
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["${var.FMC_version}*"]
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

data "template_file" "fmc_startup_file" {
  count       = var.create_fmc ? 1 : 0
  template = file("${path.module}/fmc_startup_file.txt")
  vars = {
    fmc_admin_password       = var.fmc_admin_password
    fmc_hostname             = var.fmc_hostname
  }
}

data "aws_availability_zones" "available" {
    state = "available"
}

