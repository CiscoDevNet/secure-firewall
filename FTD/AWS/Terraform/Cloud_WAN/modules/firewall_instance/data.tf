# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

data "aws_ami" "ftdv" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["${var.ftd_version}*"]
  }

  include_deprecated = true

  filter {
    name   = "product-code"
    values = ["${var.byol ? "a8sxy6easi2zumgtyr564z6y7" : "akjez2r6bd6o7tg3mhptif6ti"}"]
  }
}

data "template_file" "ftd_startup_file" {
  count    = var.instances_per_az * var.availability_zone_count
  template = file("${path.module}/ftd_startup_file.txt")
  vars = {
    fmc_ip             = var.fmc_mgmt_ip
    fmc_nat_id         = var.fmc_nat_id
    reg_key            = var.reg_key
    ftd_admin_password = var.ftd_admin_password
  }
}
