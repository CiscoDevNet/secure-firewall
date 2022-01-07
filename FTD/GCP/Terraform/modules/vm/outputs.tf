output "external_ips" {
  value       = local.vm_ips
  description = "external ips for VPC networks"
}

output "instance_ids" {
  value       = google_compute_instance.ftd[*].id
  description = "a list of instance ids"
}