output "FMC_Public_IP" {
  value       = module.vm.external_ips_fmc
  description = "Public IP of FMC"
}
