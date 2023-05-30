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
data "fmc_devices" "device" {
  name = var.ftd_name
}

################################################################################################
# Resource blocks
################################################################################################

resource "fmc_security_zone" "inside" {
  name            = "${var.devnet_pod}-inside"
  interface_mode  = "ROUTED"
}
resource "fmc_security_zone" "outside" {
  name            = "${var.devnet_pod}-outside"
  interface_mode  = "ROUTED"
}
resource "fmc_security_zone" "vni" {
  name            = "${var.devnet_pod}-vni"
  interface_mode  = "ROUTED"
}


resource "fmc_host_objects" "cisco_site" {
  name        = "Cisco"
  value       = "72.163.4.161"
}

resource "fmc_host_objects" "inside-gw" {
  name        = "inside-gateway"
  value       = var.inside_gw_ips
}

resource "fmc_ftd_nat_policies" "nat_policy" {
    name = "${var.devnet_pod}-NAT_Policy"
    description = "Nat policy by terraform"
}

resource "fmc_ftd_manualnat_rules" "new_rule" {
    nat_policy = fmc_ftd_nat_policies.nat_policy.id
    nat_type = "static"
    original_source{
        id = data.fmc_network_objects.any-ipv4.id
        type = data.fmc_network_objects.any-ipv4.type
    }
    source_interface {
        id = fmc_security_zone.outside.id
        type = "SecurityZone"
    }
    destination_interface {
        id = fmc_security_zone.inside.id
        type = "SecurityZone"
    }
    original_destination_port {
        id = data.fmc_port_objects.ssh.id
        type = data.fmc_port_objects.ssh.type
    }
    translated_destination_port {
        id = data.fmc_port_objects.http.id
        type = data.fmc_port_objects.http.type
    }
    translated_destination {
        id = fmc_host_objects.cisco_site.id
        type = fmc_host_objects.cisco_site.type
    }
    interface_in_original_destination = true
    interface_in_translated_source = true
}

resource "fmc_policy_devices_assignments" "policy_assignment" {
  policy {
      id = fmc_ftd_nat_policies.nat_policy.id
      type = fmc_ftd_nat_policies.nat_policy.type
  }
  target_devices {
      id = data.fmc_devices.device.id
      type = data.fmc_devices.device.type
  }
}

resource "fmc_ftd_deploy" "ftd" {
    depends_on = [fmc_policy_devices_assignments.policy_assignment]
    device = data.fmc_devices.device.id
    ignore_warning = true
    force_deploy = false
}


