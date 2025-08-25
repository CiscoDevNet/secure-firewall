##################
# Launch Template
##################

resource "aws_launch_template" "ftd_launch_template" {
  name                                 = "${var.env_name}-launch-template"
  image_id                             = data.aws_ami.ftdv.image_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "c5.xlarge"
  key_name                             = aws_key_pair.public_key.key_name
  network_interfaces {
    description                 = "ftd_mgmt_if"
    subnet_id                   = data.aws_subnet.mgmt_subnet.id
    delete_on_termination       = true
    device_index                = 0
    security_groups = ["${data.aws_security_group.fmc_ftd_mgmt.id}"]
  }
  user_data = base64encode(jsonencode({ "AdminPassword" : "${var.ftd_pass}" }))
}

