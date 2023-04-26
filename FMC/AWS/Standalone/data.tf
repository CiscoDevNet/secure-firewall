#########################################################################################################################
# Data
#########################################################################################################################

data "aws_vpc" "selected" {
  count = var.vpc_id == "" ? 0 : 1
  id    = var.vpc_id
}

data "aws_availability_zones" "available" {
  count = length(var.azs) > 0 ? 0 : 1
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ami" "fmcv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["${var.fmc_version}*"]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "fmc_startup_file" {
  count = var.instances
  template = file("fmc_startup_file.txt")
  vars = {
    hostname = "${var.hostname}%{if var.instances > 1}-${count.index}%{endif}"
  }
}