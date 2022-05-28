# # ##################################################################################################################################
# # # Create the Cisco FMC and FTD Instances
# # ##################################################################################################################################

resource "aws_instance" "ftdv" {
  count               = var.instances_per_az * var.availability_zone_count
  ami                 = data.aws_ami.ftdv.id
  instance_type       = var.ftd_size
  key_name            = var.keyname
  network_interface {
    network_interface_id = element(var.ftd_mgmt_interface,count.index)
    device_index         = 0
  }
  network_interface {
    network_interface_id = element(var.ftd_diag_interface,count.index)
    device_index         = 1
  }
  network_interface {
    network_interface_id = element(var.ftd_outside_interface,count.index)
    device_index         = 2
  }
  network_interface {
    network_interface_id = element(var.ftd_inside_interface,count.index)
    device_index         = 3
  }
  user_data = data.template_file.ftd_startup_file[count.index].rendered
  tags = merge({
    Name = "Cisco ftdv${count.index}"
  },var.tags)
}

resource "aws_instance" "fmcv" {
  ami                 = data.aws_ami.fmcv.id
  instance_type       = "c5.4xlarge"
  key_name            = var.keyname   
  network_interface {
    network_interface_id = var.fmcmgmt_interface
    device_index         = 0
  }
  user_data = data.template_file.fmc_startup_file.rendered
  tags = {
    Name = "Cisco FMCv"
  }
}

# resource "aws_key_pair" "deployer2"{
#   key_name = "KeyPlay"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu6N6+MpZ727ujLHwgjrTwMFEXccXM7baxEwUta87G17/HTeDxC7rdRh+V75cGj368iM9ZYBBiwadQ2Q03Y2c9vNNpeL0UDGpCFlg/s36EByt+uOXF92HlSDgY8W8x34QdX0IYCZolC+DvAwGqtlbuMUwPl+fDQapvroZSqD5NqTYNc0d7vRvDZzdk73zZz8vbEJKYoioBzfbJ6ebNTyFlA7frn82fynMyGy4RpKM1m0v+3NMwxgFoEqXiSVkarkEtT7ABUy+nvNOCUK50S5E8dTSDPldgufOQ+Z71ieW45C+qr5jsVDo0HxwOKu5nrhtK+er/r2HanbYFsXPxLdwR kadadhic@KADADHIC-M-L059"
# }
