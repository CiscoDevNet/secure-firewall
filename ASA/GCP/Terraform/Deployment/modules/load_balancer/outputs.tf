output "external_ip_ext_fr" {
  description = "The external ip address of the forwarding rule."
  value       = google_compute_forwarding_rule.asa-ext-fr.ip_address
}

output "internal_ip_ext_fr" {
  description = "The  ip address of the forwarding rule."
  value       = try(google_compute_forwarding_rule.asa-int-fr[0].ip_address, "")
}