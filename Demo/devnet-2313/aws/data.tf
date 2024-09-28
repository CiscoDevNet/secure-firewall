data "aws_ami" "ftdv" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["${var.FTD_version}*"]
  }

  include_deprecated = true

  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }
}
#one file should be good for all
data "template_file" "ftd_startup_file" {
  count    = var.create_fmc ? 1 : 0
  template = file("${path.module}/templates/ftd_startup.txt")
  vars = {
    admin_password = var.admin_password
    fmc_ip         = var.fmc_ip
    fmc_nat_id     = var.fmc_nat_id
    reg_key        = var.reg_key
  }
}
data "aws_ami" "fmcv" {
  most_recent = true // you can enable this if you want to deploy more
  count       = var.create_fmc ? 1 : 0
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["${var.FMC_version}*"]
  }

  include_deprecated = true

  filter {
    name   = "product-code"
    values = ["bhx85r4r91ls2uwl69ajm9v1b"]
  }
}

data "template_file" "fmc_startup_file" {
  count    = var.create_fmc ? 1 : 0
  template = file("${path.module}/templates/fmc_startup.txt")
  vars = {
    admin_password = var.admin_password
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

