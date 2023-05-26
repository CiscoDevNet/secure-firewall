################################################################################################
# Check ---->  https://registry.terraform.io/providers/CiscoDevNet/fmc/latest For more information
################################################################################################
terraform {
  required_providers {
    fmc = {
      source = "CiscoDevNet/fmc"
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
data "fmc_device_physical_interfaces" "zero_physical_interface" {
    count = var.insCount
    device_id = data.fmc_devices.device[count.index].id
    name = "TenGigabitEthernet0/0"
}
data "fmc_device_physical_interfaces" "one_physical_interface" {
    count = var.insCount
    device_id = data.fmc_devices.device[count.index].id
    name = "TenGigabitEthernet0/1"
}

################################################################################################
# Resource blocks
################################################################################################
resource "fmc_security_zone" "inside" {
  name            = "inside"
  interface_mode  = "ROUTED"
}
resource "fmc_security_zone" "outside" {
  name            = "outside"
  interface_mode  = "ROUTED"
}
resource "fmc_security_zone" "vni" {
  name            = "vni"
  interface_mode  = "ROUTED"
}
resource "fmc_host_objects" "aws_meta" {
  name        = "aws_metadata_server"
  value       = "169.254.169.254"
}
resource "fmc_host_objects" "inside-gw" {
  count = var.insCount
  name        = "inside-gateway${count.index+1}"
  value       = var.inside_gw_ips[count.index]
}

resource "fmc_access_policies" "access_policy" {
  name = "Terraform Access Policy"
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

resource "fmc_ftd_nat_policies" "nat_policy" {
    count = var.insCount
    name = "NAT_Policy${count.index}"
    description = "Nat policy by terraform"
}

resource "fmc_ftd_manualnat_rules" "new_rule" {
    count = var.insCount
    nat_policy = fmc_ftd_nat_policies.nat_policy[count.index].id
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
        id = fmc_host_objects.aws_meta.id
        type = fmc_host_objects.aws_meta.type
    }
    interface_in_original_destination = true
    interface_in_translated_source = true
}

resource "fmc_devices" "device1"{
  depends_on = [fmc_ftd_nat_policies.nat_policy, fmc_security_zone.inside, fmc_security_zone.outside]
  name = "FTD1"
  hostname = var.ftd_ips[0]
  regkey = "cisco"
  type = "Device"
  license_caps = [ "MALWARE"]
  nat_id = "cisco"
  access_policy {
      id = fmc_access_policies.access_policy.id
      type = fmc_access_policies.access_policy.type
  }
}
resource "fmc_devices" "device2"{
  depends_on = [fmc_devices.device1]
  name = "FTD2"
  hostname = var.ftd_ips[1]
  regkey = "cisco"
  type = "Device"
  license_caps = [ "MALWARE"]
  nat_id = "cisco"
  access_policy {
      id = fmc_access_policies.access_policy.id
      type = fmc_access_policies.access_policy.type
  }
}
##############################
#Intermediate data block for devices
##############################
data "fmc_devices" "device" {
  depends_on = [fmc_devices.device2]
  count = var.insCount
  name = "FTD${count.index+1}"
}
##############################
resource "fmc_device_physical_interfaces" "physical_interfaces00" {
    count = var.insCount
    enabled = true
    device_id = data.fmc_devices.device[count.index].id
    physical_interface_id= data.fmc_device_physical_interfaces.zero_physical_interface[count.index].id
    name =   data.fmc_device_physical_interfaces.zero_physical_interface[count.index].name
    security_zone_id= fmc_security_zone.outside.id
    if_name = "outside"
    description = "Applied by terraform"
    mtu =  1900
    mode = "NONE"
    ipv4_dhcp_enabled = true
    ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interfaces" "physical_interfaces01" {
    count = var.insCount
    device_id = data.fmc_devices.device[count.index].id
    physical_interface_id= data.fmc_device_physical_interfaces.one_physical_interface[count.index].id
    name =   data.fmc_device_physical_interfaces.one_physical_interface[count.index].name
    security_zone_id= fmc_security_zone.inside.id
    if_name = "inside"
    description = "Applied by terraform"
    mtu =  1900
    mode = "NONE"
    ipv4_dhcp_enabled = true
    ipv4_dhcp_route_metric = 1
}

resource "fmc_staticIPv4_route" "route" {
  depends_on = [data.fmc_devices.device, fmc_device_physical_interfaces.physical_interfaces00,fmc_device_physical_interfaces.physical_interfaces01]
  count = var.insCount
  metric_value = 25
  device_id  = data.fmc_devices.device[count.index].id
  interface_name = "inside"
  selected_networks {
      id = fmc_host_objects.aws_meta.id
      type = fmc_host_objects.aws_meta.type
      name = fmc_host_objects.aws_meta.name
  }
  gateway {
    object {
      id   = fmc_host_objects.inside-gw[count.index].id
      type = fmc_host_objects.inside-gw[count.index].type
      name = fmc_host_objects.inside-gw[count.index].name
    }
  }
}

resource "fmc_policy_devices_assignments" "policy_assignment" {
  depends_on = [fmc_staticIPv4_route.route]
  count = var.insCount
  policy {
      id = fmc_ftd_nat_policies.nat_policy[count.index].id
      type = fmc_ftd_nat_policies.nat_policy[count.index].type
  }
  target_devices {
      id = data.fmc_devices.device[count.index].id
      type = data.fmc_devices.device[count.index].type
  }
}

resource "fmc_device_vtep" "vtep_policies" {
    depends_on = [fmc_staticIPv4_route.route]
    count = var.insCount
    device_id = data.fmc_devices.device[count.index].id
    nve_enabled = true

    nve_vtep_id = 1
    nve_encapsulation_type = "GENEVE"
    nve_destination_port = 6081
    source_interface_id = data.fmc_device_physical_interfaces.zero_physical_interface[count.index].id 
}
resource "fmc_device_vni" "vni" {
    depends_on = [fmc_device_vtep.vtep_policies]
    count = var.insCount
    device_id = data.fmc_devices.device[count.index].id
    if_name = "vni${count.index+1}"
    description = "Applied via terraform"
    security_zone_id= fmc_security_zone.outside.id
    vnid = count.index+1 
    enable_proxy = true
    enabled = true
    vtep_id = 1
}

resource "fmc_ftd_deploy" "ftd" {
    depends_on = [fmc_device_vni.vni, fmc_device_vtep.vtep_policies, fmc_policy_devices_assignments.policy_assignment]
    count = var.insCount
    device = data.fmc_devices.device[count.index].id
    ignore_warning = true
    force_deploy = false
}


