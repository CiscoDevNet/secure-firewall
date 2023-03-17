output "external_ips_ftd" {
  value       = local.vm_ips_ftd
  description = "external ips for VPC networks-FTD"
}
output "external_ips_fmc" {
  value       = local.vm_ips_fmc
  description = "external ips for VPC networks-FMC"
}
output "instance_ids" {
  value       = google_compute_instance.ftd[*].id
  description = "a list of instance ids"
}