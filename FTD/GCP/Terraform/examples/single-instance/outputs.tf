output "FMC_Public_IP" {
  value       = module.vm.external_ips_fmc
  description = "Public IP of FMC"
}
output "FTD_Public_IP" {
  value       = module.vm.external_ips_ftd
  description = "Public IP of FMC"
}
