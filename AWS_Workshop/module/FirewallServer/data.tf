data "aws_ami" "ftdv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["${var.FTD_version}*"]
  }
}
#one file should be good for all
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
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["${var.FMC_version}*"]
  }
}

data "template_file" "fmc_startup_file" {
  template = file("${path.module}/fmc_startup_file.txt")
  vars = {
    fmc_admin_password       = var.fmc_admin_password
    fmc_hostname             = var.fmc_hostname
  }
}

data "aws_availability_zones" "available" {
    state = "available"
}

