# # ##################################################################################################################################
# # # Create the Cisco FMC and FTD Instances
# # ##################################################################################################################################
locals {
  rendered_ftd_startup_files = [
    for idx in range(var.instances_per_az * var.availability_zone_count) : templatefile("${path.module}/ftd_startup_file.txt.tfpl", {
      fmc_ip     = var.fmc_mgmt_ip,
      fmc_nat_id = var.fmc_nat_id,
      reg_key    = var.reg_key
    })
  ]
}

resource "aws_instance" "ftdv" {
  count         = var.instances_per_az * var.availability_zone_count
  ami           = data.aws_ami.ftdv.id
  instance_type = var.ftd_size
  key_name      = var.keyname
  network_interface {
    network_interface_id = element(var.ftd_mgmt_interface, count.index)
    device_index         = 0
  }
  network_interface {
    network_interface_id = element(var.ftd_diag_interface, count.index)
    device_index         = 1
  }
  network_interface {
    network_interface_id = element(var.ftd_outside_interface, count.index)
    device_index         = 2
  }
  network_interface {
    network_interface_id = element(var.ftd_inside_interface, count.index)
    device_index         = 3
  }
  user_data = local.rendered_ftd_startup_files[count.index]
  tags = merge({
    Name = "Cisco ftdv${count.index}"
  }, var.tags)
}

resource "aws_instance" "fmcv" {
  ami           = data.aws_ami.fmcv.id
  instance_type = "c5.4xlarge"
  key_name      = var.keyname
  network_interface {
    network_interface_id = var.fmcmgmt_interface
    device_index         = 0
  }
  user_data = base64encode(templatefile("${path.module}/fmc_startup_file.txt.tfpl",
    {
      fmc_admin_password = var.fmc_admin_password
      fmc_hostname       = var.fmc_hostname
  }))
  tags = {
    Name = "Cisco FMCv"
  }
}
