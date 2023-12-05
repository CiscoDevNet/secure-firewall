data "aws_ami" "ftdv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners      = ["399918941163"]
  filter {
    name   = "name"
    values = ["ftdv-7.1.0-92-ENA"]
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

data "aws_availability_zones" "available" {
    state = "available"
}

