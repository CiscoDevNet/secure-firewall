output "external_lb_ip" {
  description = "The external ip address of the public LB"
  value       = oci_network_load_balancer_network_load_balancer.external_nlb.ip_addresses[0].ip_address
}

output "internal_lb_ip" {
  description = "The internal ip address of the private LB"
  value       = oci_network_load_balancer_network_load_balancer.internal_nlb.ip_addresses[0].ip_address
}
