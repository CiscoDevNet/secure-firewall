# # ##################################################################################################################################
# # # Create the Cisco ASA01 Instances (First Instance)
# # ##################################################################################################################################

resource "aws_instance" "asav" {
  count = var.instances_per_az * var.availability_zone_count
  ami                 = data.aws_ami.asav.id
  instance_type = var.asa_size
  key_name      = var.keyname

  network_interface {
    network_interface_id = element(var.asa_mgmt_interface,count.index)
    device_index         = 0
  }

  network_interface {
    network_interface_id = element(var.asa_outside_interface,count.index)
    device_index         = 1
  }

  network_interface {
    network_interface_id = element(var.asa_inside_interface,count.index)
    device_index         = 2
  }

  network_interface {
    network_interface_id = element(var.asa_dmz_interface,count.index)
    device_index         = 3
  }

  user_data = data.template_file.asa_startup_file.rendered


  tags = merge({
    Name = "Cisco asav${count.index}"
  },var.tags)
}