data "fmc_port_objects" "http" {
    name = "HTTP"
}

data "fmc_port_objects" "ssh" {
    name = "SSH"
}

resource "fmc_access_policies" "access_policy" {
  name = "IAC-ACP"
  default_action = "BLOCK"
  default_action_send_events_to_fmc = "true"
  default_action_log_end = "true"
}

resource "fmc_security_zone" "inside" {
  name            = "inside"
  interface_mode  = "ROUTED"
}
resource "fmc_security_zone" "outside" {
  name            = "outside"
  interface_mode  = "ROUTED"
}

resource "fmc_host_objects" "inside-gw" {
  count = 2
  name        = "inside-gateway${count.index+1}"
  value       = var.inside_gateway[count.index]
}

resource "fmc_host_objects" "outside-gw" {
  count = 2
  name        = "default-gateway${count.index+1}"
  value       = var.outside_gateway[count.index]
}

resource "fmc_host_objects" "ELB" {
  count = 2
  name        = "ELB${count.index+1}"
  value       = var.elb[count.index]
}

resource "fmc_host_objects" "APP-LB" {
  count = 2
  name        = "app-lb${count.index+1}"
  value       = var.app_lb[count.index]
}

resource "fmc_network_objects" "APP" {
  count = 2
  name        = "APP${count.index+1}"
  value       = var.ftd_app_ip[count.index]
}

resource "fmc_access_rules" "access_rule_1" {
    acp = fmc_access_policies.access_policy.id
    section = "mandatory"
    name = "To Web Server"
    action = "allow"
    enabled = true
    send_events_to_fmc = true
    log_end = true
    source_zones {
        source_zone {
            id = fmc_security_zone.outside.id
            type = "SecurityZone"
        }
    }
    destination_zones {
        destination_zone {
            id = fmc_security_zone.inside.id
            type = "SecurityZone"
        }
    }
    destination_networks {
        destination_network {
            id = fmc_host_objects.APP-LB[0].id
            type =  fmc_host_objects.APP-LB[0].type
        }
        destination_network {
            id = fmc_host_objects.APP-LB[1].id
            type =  fmc_host_objects.APP-LB[1].type
        }
    }
    new_comments = [ "Traffic to Web Server" ]
}

resource "fmc_ftd_nat_policies" "nat_policy" {
    count = 2
    name = "NAT_Policy${count.index}"
    description = "Nat policy by terraform"
}

resource "fmc_ftd_manualnat_rules" "new_rule1" {
    count = 2
    nat_policy = fmc_ftd_nat_policies.nat_policy[count.index].id
    nat_type = "static"
    original_source{
        id = fmc_host_objects.ELB[0].id
        type = fmc_host_objects.ELB[0].type
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
        id = data.fmc_port_objects.http.id
        type = data.fmc_port_objects.http.type
    }
    translated_destination_port {
        id = data.fmc_port_objects.http.id
        type = data.fmc_port_objects.http.type
    }
    translated_destination {
        id = fmc_host_objects.APP-LB[0].id
        type = fmc_host_objects.APP-LB[0].type
    }
    interface_in_original_destination = true
    interface_in_translated_source = true
}

resource "fmc_ftd_manualnat_rules" "new_rule2" {
    count = 2
    nat_policy = fmc_ftd_nat_policies.nat_policy[count.index].id
    nat_type = "static"
    original_source{
        id = fmc_host_objects.ELB[1].id
        type = fmc_host_objects.ELB[1].type
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
        id = data.fmc_port_objects.http.id
        type = data.fmc_port_objects.http.type
    }
    translated_destination_port {
        id = data.fmc_port_objects.http.id
        type = data.fmc_port_objects.http.type
    }
    translated_destination {
        id = fmc_host_objects.APP-LB[1].id
        type = fmc_host_objects.APP-LB[1].type
    }
    interface_in_original_destination = true
    interface_in_translated_source = true
}

resource "fmc_devices" "device1"{
  depends_on = [fmc_ftd_nat_policies.nat_policy, fmc_security_zone.inside, fmc_security_zone.outside]
  name = "FTD1"
  hostname = var.ftd_mgmt_ip[0]
  regkey = "cisco"
  type = "Device"
  #license_caps = [ "MALWARE"]
  #nat_id = "cisco"
  access_policy {
      id = fmc_access_policies.access_policy.id
      type = fmc_access_policies.access_policy.type
  }
}
resource "fmc_devices" "device2"{
  depends_on = [fmc_devices.device1]
  name = "FTD2"
  hostname = var.ftd_mgmt_ip[1]
  regkey = "cisco"
  type = "Device"
  #license_caps = [ "MALWARE"]
  #nat_id = "cisco"
  access_policy {
      id = fmc_access_policies.access_policy.id
      type = fmc_access_policies.access_policy.type
  }
}

data "fmc_devices" "device" {
  depends_on = [fmc_devices.device2]
  count = 2
  name = "FTD${count.index+1}"
}

data "fmc_device_physical_interfaces" "zero_physical_interface" {
    count = 2
    device_id = data.fmc_devices.device[count.index].id
    name = "TenGigabitEthernet0/0"
}

data "fmc_device_physical_interfaces" "one_physical_interface" {
    count = 2
    device_id = data.fmc_devices.device[count.index].id
    name = "TenGigabitEthernet0/1"
}

resource "fmc_device_physical_interfaces" "physical_interfaces00" {
    count = 2
    enabled = true
    device_id = data.fmc_devices.device[count.index].id
    physical_interface_id= data.fmc_device_physical_interfaces.zero_physical_interface[count.index].id
    name =   data.fmc_device_physical_interfaces.zero_physical_interface[count.index].name
    security_zone_id= fmc_security_zone.outside.id
    if_name = "outside"
    mode = "NONE"
    ipv4_dhcp_enabled = true
    ipv4_dhcp_route_metric = 1
}

resource "fmc_device_physical_interfaces" "physical_interfaces01" {
    count = 2
    enabled = true
    device_id = data.fmc_devices.device[count.index].id
    physical_interface_id= data.fmc_device_physical_interfaces.one_physical_interface[count.index].id
    name =   data.fmc_device_physical_interfaces.one_physical_interface[count.index].name
    security_zone_id= fmc_security_zone.inside.id
    if_name = "inside"
    mode = "NONE"
    ipv4_dhcp_enabled = true
    ipv4_dhcp_route_metric = 1
}

resource "fmc_staticIPv4_route" "route" {
  depends_on = [data.fmc_devices.device, fmc_device_physical_interfaces.physical_interfaces00,fmc_device_physical_interfaces.physical_interfaces01]
  count = 2
  metric_value = 1
  device_id  = data.fmc_devices.device[count.index].id
  interface_name = "inside"
  selected_networks {
      id = fmc_network_objects.APP[count.index].id
      type = fmc_network_objects.APP[count.index].type
      name = fmc_network_objects.APP[count.index].name
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
  count = 2
  policy {
      id = fmc_ftd_nat_policies.nat_policy[count.index].id
      type = fmc_ftd_nat_policies.nat_policy[count.index].type
  }
  target_devices {
      id = data.fmc_devices.device[count.index].id
      type = data.fmc_devices.device[count.index].type
  }
}

resource "fmc_ftd_deploy" "ftd" {
    depends_on = [fmc_policy_devices_assignments.policy_assignment]
    count = 2
    device = data.fmc_devices.device[count.index].id
    ignore_warning = true
    force_deploy = false
}