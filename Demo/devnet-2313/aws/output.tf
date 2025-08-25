output "FMC_URL" {
  value = "https://${aws_eip.fmcmgmt-EIP[0].public_ip}"
}
output "FTD_IP" {
  value = aws_eip.ftd01mgmt-EIP.public_ip
}
output "SSH_Command_FTD" {
  value = "ssh -i ${var.prefix}-Cisco-Key admin@${aws_eip.ftd01mgmt-EIP.public_ip}"
}
output "SSH_Command_Bastion_IP" {
  value = "ssh -i ${var.prefix}-Cisco-Key admin@${aws_instance.testLinux.public_ip}"
}
