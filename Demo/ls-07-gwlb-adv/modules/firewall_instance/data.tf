# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

data "aws_ami" "ftdv" {
  #most_recent = true
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["${var.ftd_version}*"]
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

# data "template_file" "ftd_startup_file" {
#   count    = var.instances_per_az * var.availability_zone_count
#   template = file("${path.module}/ftd_startup_file.txt")
#   vars = {
#     fmc_ip     = var.fmc_mgmt_ip
#     fmc_nat_id = var.fmc_nat_id
#     reg_key    = var.reg_key
#   }
# }
data "template_file" "ftd_startup_file" {
  count    = var.instances_per_az * var.availability_zone_count
  template = file("${path.module}/ftd_startup_file.txt")
  vars = {
    fmc_ip     = cdo_ftd_device.test[count.index].hostname
    fmc_nat_id = cdo_ftd_device.test[count.index].nat_id
    reg_key    = cdo_ftd_device.test[count.index].reg_key
  }
}

data "aws_ami" "fmcv" {
  #most_recent = true
  count  = var.create_fmc ? 1 : 0
  owners = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["${var.fmc_version}*"]
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
  count    = var.create_fmc ? 1 : 0
  template = file("${path.module}/fmc_startup_file.txt")
  vars = {
    fmc_admin_password = var.fmc_admin_password
    fmc_hostname       = var.fmc_hostname
  }
}

