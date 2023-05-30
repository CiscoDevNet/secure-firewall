terraform {
  required_providers {
    fmc = {
      source = "CiscoDevNet/fmc"
      # version = "0.1.1"
    }
  }
}

provider "fmc" {
  fmc_username = var.fmc_username
  fmc_password = var.fmc_password
  fmc_host = var.fmc_host
  fmc_insecure_skip_verify = var.fmc_insecure_skip_verify
}

################################################################################################
# Data blocks
################################################################################################
data "fmc_port_objects" "http" {
    name = "HTTP"
}
data "fmc_port_objects" "ssh" {
    name = "SSH"
}
data "fmc_network_objects" "any-ipv4"{
    name = "any-ipv4"
}

################################################################################################
# Resource blocks
################################################################################################
resource "fmc_host_objects" "aws_meta" {
  name        = "aws_metadata_server"
  value       = "169.254.169.254"
}

resource "fmc_access_policies" "access_policy" {
  name = "${var.devnet_pod}-Terraform Access Policy"
  default_action = "BLOCK"
  default_action_send_events_to_fmc = "true"
  default_action_log_end = "true"
}

resource "fmc_access_rules" "access_rule_1" {
    acp = fmc_access_policies.access_policy.id
    section = "mandatory"
    name = "Rule-1"
    action = "allow"
    enabled = true
    # syslog_severity = "alert"
    # enable_syslog = true
    send_events_to_fmc = true
    log_end = true
    destination_networks {
        destination_network {
            id = fmc_host_objects.aws_meta.id
            type =  fmc_host_objects.aws_meta.type
        }
    }
    destination_ports {
        destination_port {
            id = data.fmc_port_objects.http.id
            type =  data.fmc_port_objects.http.type
        }
    }
    new_comments = [ "Testing via terraform" ]
}

resource "fmc_devices" "devnet-clus23-ftd-10" {
  name = var.ftd_hostname
  hostname = var.ftd_ips
  regkey = var.ftd_registration_key
  #type = "Device"
  #license_caps = [ "MALWARE"]
  license_caps = []
  nat_id = ""
  access_policy {
      id = fmc_access_policies.access_policy.id
      type = fmc_access_policies.access_policy.type
  }
}
