# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

output "ftd_instance_id" {
  description = "FTD instance ID"
  value       = aws_instance.ftdv.*.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ftdv.*.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ftdv.*.private_ip
}

output "fmc_instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.fmcv.*.private_ip
}