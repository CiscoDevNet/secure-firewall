output "ssh_firewall_rule" {
  value       = google_compute_firewall.allow-ssh-mgmt
  description = "The created ssh firewall rule resources"
}

output "https_firewall_rule" {
  value       = google_compute_firewall.allow-https-mgmt
  description = "The created https firewall rule resources"
}