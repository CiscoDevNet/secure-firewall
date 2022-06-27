output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ftdv.*.public_ip
}

output "instance_private_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ftdv.*.private_ip
}