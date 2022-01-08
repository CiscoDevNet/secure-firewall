output "external_ips" {
  value       = oci_core_instance.ftd.*.public_ip
  description = "external ips for VPC networks"
}
output "private_ips" {
  description = "Private IPs of created instances. "
  value       = oci_core_instance.ftd.*.private_ip
}

output "instance_ids" {
  description = "ocid of created instances. "
  value       = oci_core_instance.ftd.*.id
}