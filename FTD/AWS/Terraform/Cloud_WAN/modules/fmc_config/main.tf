#--------------------------------------------------------------------
# FMC Configuration
#--------------------------------------------------------------------

# ################################################################################################
# # Data blocks
# ################################################################################################
data "fmc_port_objects" "http" {
  name = "HTTP"
}
data "fmc_port_objects" "ssh" {
  name = "SSH"
}
data "fmc_network_objects" "any_ipv4" {
  name = "any-ipv4"
}
data "fmc_network_group_objects" "ipv4-rfc1918" {
  name = "IPv4-Private-All-RFC1918"
}
data "fmc_device_physical_interfaces" "zero_physical_interface" {
  count     = var.inscount
  device_id = data.fmc_devices.device[count.index].id
  name      = "${(tonumber(split("", split(".", trimprefix(var.ftd_version, "ftdv-"))[0])[0]) == 7) ? (tonumber(split("", split(".", trimprefix(var.ftd_version, "ftdv-"))[1])[0]) < 8) ? "TenGigabit" : "" : ""}Ethernet0/0"
}
data "fmc_device_physical_interfaces" "one_physical_interface" {
  count     = var.inscount
  device_id = data.fmc_devices.device[count.index].id
  name      = "${(tonumber(split("", split(".", trimprefix(var.ftd_version, "ftdv-"))[0])[0]) == 7) ? (tonumber(split("", split(".", trimprefix(var.ftd_version, "ftdv-"))[1])[0]) < 8) ? "TenGigabit" : "" : ""}Ethernet0/1"
}

# ################################################################################################
# # Resource blocks
# ################################################################################################
# resource "fmc_smart_license" "license" {
#   registration_type = "EVALUATION"
# }
resource "fmc_security_zone" "inside" {
  # depends_on     = [fmc_smart_license.license]
  name           = "inside"
  interface_mode = "ROUTED"
}
resource "fmc_security_zone" "outside" {
  depends_on     = [fmc_security_zone.inside]
  name           = "outside"
  interface_mode = "ROUTED"
}
resource "fmc_security_zone" "vni" {
  depends_on     = [fmc_security_zone.outside]
  name           = "vni"
  interface_mode = "ROUTED"
}
resource "fmc_host_objects" "inside_gw" {
  depends_on = [fmc_security_zone.vni]
  count      = var.inscount
  name       = "inside-gateway${count.index + 1}"
  value      = local.ftd_inside_gw[count.index]
}
resource "fmc_host_objects" "outside_gw" {
  depends_on = [fmc_host_objects.inside_gw]
  count      = var.inscount
  name       = "outside-gateway${count.index + 1}"
  value      = local.ftd_outside_gw[count.index]
}
resource "fmc_host_objects" "aws_meta" {
  depends_on = [fmc_host_objects.outside_gw]
  name       = "aws_metadata_server"
  value      = "169.254.169.254"
}
resource "fmc_network_objects" "anyipv4" {
  depends_on = [fmc_host_objects.aws_meta]
  name       = "anyipv4"
  value      = "0.0.0.0/0"
}
resource "fmc_access_policies" "access_policy" {
  depends_on                        = [fmc_network_objects.anyipv4]
  name                              = "GWLB-ACP"
  default_action                    = "BLOCK"
  default_action_send_events_to_fmc = "true"
  default_action_log_end            = "true"
}

resource "fmc_access_rules" "access_rule_1" {
  acp     = fmc_access_policies.access_policy.id
  section = "mandatory"
  name    = "Rule-1"
  action  = "allow"
  enabled = true
  # syslog_severity = "alert"
  # enable_syslog = true
  send_events_to_fmc = true
  log_end            = true
  destination_networks {
    destination_network {
      id   = fmc_host_objects.aws_meta.id
      type = fmc_host_objects.aws_meta.type
    }
  }
  destination_ports {
    destination_port {
      id   = data.fmc_port_objects.http.id
      type = data.fmc_port_objects.http.type
    }
  }
  new_comments = ["Testing via terraform"]
}

resource "fmc_access_rules" "access_rule_2" {
  acp                = fmc_access_policies.access_policy.id
  section            = "mandatory"
  name               = "in-out"
  action             = "allow"
  enabled            = true
  send_events_to_fmc = true
  log_end            = true
  source_zones {
    source_zone {
      id   = fmc_security_zone.vni.id
      type = fmc_security_zone.vni.type
    }
  }
  destination_zones {
    destination_zone {
      id   = fmc_security_zone.outside.id
      type = fmc_security_zone.outside.type
    }
  }
}

resource "fmc_ftd_nat_policies" "nat_policy" {
  depends_on  = [fmc_access_rules.access_rule_1, fmc_access_rules.access_rule_2]
  count       = var.inscount
  name        = "NAT_Policy${count.index}"
  description = "Nat policy by terraform"
}

resource "fmc_ftd_autonat_rules" "new_rule2" {
  count      = var.inscount
  nat_policy = fmc_ftd_nat_policies.nat_policy[count.index].id
  nat_type   = "dynamic"
  original_network {
    id   = fmc_network_objects.anyipv4.id
    type = fmc_network_objects.anyipv4.type
  }
  source_interface {
    id   = fmc_security_zone.vni.id
    type = "SecurityZone"
  }
  destination_interface {
    id   = fmc_security_zone.outside.id
    type = "SecurityZone"
  }
  translated_network_is_destination_interface = true
}

# resource "fmc_devices" "ftd_registration" {
#   count        = var.inscount
#   name         = local.instance_names[count.index]
#   hostname     = var.ftd_mgmt_ips[count.index]
#   regkey       = var.reg_key
#   nat_id       = var.fmc_nat_id
#   license_caps = ["MALWARE"]
#   access_policy {
#     id   = fmc_access_policies.access_policy.id
#     type = fmc_access_policies.access_policy.type
#   }
# }

resource "local_file" "tfvars" {
  depends_on = [fmc_ftd_autonat_rules.new_rule2]
  filename   = "${path.module}/device_registration/terraform.tfvars"
  content    = <<-EOT
fmc_mgmt_ip = "${var.fmc_mgmt_ip}"
fmc_username = "${var.fmc_username}"
fmc_password = "${var.fmc_password}"
fmc_insecure_skip_verify = ${var.fmc_insecure_skip_verify}
inscount = ${var.inscount}
reg_key = "${var.reg_key}"
fmc_nat_id = "${var.fmc_nat_id}"
ftd_mgmt_ips = ["${join("\", \"", var.ftd_mgmt_ips)}"]
access_policy_id = "${fmc_access_policies.access_policy.id}"
access_policy_type = "${fmc_access_policies.access_policy.type}"
instance_names = ["${join("\", \"", local.instance_names)}"]
performance_tier = "${var.performance_tier}"
  EOT
}

resource "null_resource" "device_registration" {
  depends_on = [local_file.tfvars]
  provisioner "local-exec" {
    command     = "terraform init && terraform apply --auto-approve -parallelism=1"
    working_dir = "${path.module}/device_registration/"
    when        = create
  }

  provisioner "local-exec" {
    command     = "terraform destroy --auto-approve -parallelism=1 && rm -rf .terraform && rm -rf terraform.* && rm -rf .terraform.*"
    working_dir = "${path.module}/device_registration/"
    when        = destroy
  }
}

##############################
#Intermediate data block for devices
##############################
data "fmc_devices" "device" {
  depends_on = [null_resource.device_registration]
  count      = var.inscount
  name       = local.instance_names[count.index]
}

##############################
resource "fmc_device_physical_interfaces" "physical_interfaces00" {
  count                  = var.inscount
  enabled                = true
  device_id              = data.fmc_devices.device[count.index].id
  physical_interface_id  = data.fmc_device_physical_interfaces.zero_physical_interface[count.index].id
  name                   = data.fmc_device_physical_interfaces.zero_physical_interface[count.index].name
  security_zone_id       = fmc_security_zone.outside.id
  if_name                = "outside"
  description            = "Applied by terraform"
  mtu                    = 1900
  mode                   = "NONE"
  ipv4_dhcp_enabled      = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interfaces" "physical_interfaces01" {
  count                  = var.inscount
  device_id              = data.fmc_devices.device[count.index].id
  physical_interface_id  = data.fmc_device_physical_interfaces.one_physical_interface[count.index].id
  name                   = data.fmc_device_physical_interfaces.one_physical_interface[count.index].name
  security_zone_id       = fmc_security_zone.inside.id
  if_name                = "inside"
  description            = "Applied by terraform"
  mtu                    = 1900
  mode                   = "NONE"
  ipv4_dhcp_enabled      = true
  ipv4_dhcp_route_metric = 1
}

resource "fmc_staticIPv4_route" "route" {
  depends_on     = [data.fmc_devices.device, fmc_device_physical_interfaces.physical_interfaces00, fmc_device_physical_interfaces.physical_interfaces01]
  count          = var.inscount
  metric_value   = 2
  device_id      = data.fmc_devices.device[count.index].id
  interface_name = "inside"
  selected_networks {
    id   = data.fmc_network_objects.any_ipv4.id
    type = data.fmc_network_objects.any_ipv4.type
    name = data.fmc_network_objects.any_ipv4.name
  }
  gateway {
    object {
      id   = fmc_host_objects.inside_gw[count.index].id
      type = fmc_host_objects.inside_gw[count.index].type
      name = fmc_host_objects.inside_gw[count.index].name
    }
  }
}

resource "fmc_staticIPv4_route" "route2" {
  depends_on     = [data.fmc_devices.device, fmc_device_physical_interfaces.physical_interfaces00, fmc_device_physical_interfaces.physical_interfaces01]
  count          = var.inscount
  metric_value   = 1
  device_id      = data.fmc_devices.device[count.index].id
  interface_name = "outside"
  selected_networks {
    id   = data.fmc_network_objects.any_ipv4.id
    type = data.fmc_network_objects.any_ipv4.type
    name = data.fmc_network_objects.any_ipv4.name
  }
  gateway {
    object {
      id   = fmc_host_objects.outside_gw[count.index].id
      type = fmc_host_objects.outside_gw[count.index].type
      name = fmc_host_objects.outside_gw[count.index].name
    }
  }
}

resource "fmc_staticIPv4_route" "route3" {
  depends_on     = [data.fmc_devices.device, fmc_device_physical_interfaces.physical_interfaces00, fmc_device_physical_interfaces.physical_interfaces01, fmc_device_vni.vni]
  count          = var.inscount
  metric_value   = 1
  device_id      = data.fmc_devices.device[count.index].id
  interface_name = "vni"
  selected_networks {
    id   = data.fmc_network_group_objects.ipv4-rfc1918.id
    type = data.fmc_network_group_objects.ipv4-rfc1918.type
    name = data.fmc_network_group_objects.ipv4-rfc1918.name
  }
  gateway {
    object {
      id   = fmc_host_objects.inside_gw[count.index].id
      type = fmc_host_objects.inside_gw[count.index].type
      name = fmc_host_objects.inside_gw[count.index].name
    }
  }
}

resource "fmc_policy_devices_assignments" "policy_assignment" {
  depends_on = [fmc_staticIPv4_route.route]
  count      = var.inscount
  policy {
    id   = fmc_ftd_nat_policies.nat_policy[count.index].id
    type = fmc_ftd_nat_policies.nat_policy[count.index].type
  }
  target_devices {
    id   = data.fmc_devices.device[count.index].id
    type = data.fmc_devices.device[count.index].type
  }
}

resource "fmc_device_vtep" "vtep_policies" {
  depends_on  = [fmc_staticIPv4_route.route]
  count       = var.inscount
  device_id   = data.fmc_devices.device[count.index].id
  nve_enabled = true

  nve_vtep_id            = 1
  nve_encapsulation_type = "GENEVE"
  nve_destination_port   = 6081
  source_interface_id    = data.fmc_device_physical_interfaces.one_physical_interface[count.index].id
}

resource "fmc_device_vni" "vni" {
  depends_on       = [fmc_device_vtep.vtep_policies]
  count            = var.inscount
  device_id        = data.fmc_devices.device[count.index].id
  if_name          = "vni"
  description      = "Applied via terraform"
  security_zone_id = fmc_security_zone.vni.id
  vnid             = 1
  enable_proxy     = true
  proxy_type       = "DUAL_ARM"
  enabled          = true
  vtep_id          = 1
}

resource "fmc_ftd_deploy" "ftd" {
  depends_on     = [fmc_device_vni.vni, fmc_device_vtep.vtep_policies, fmc_policy_devices_assignments.policy_assignment]
  count          = var.inscount
  device         = data.fmc_devices.device[count.index].id
  ignore_warning = true
  force_deploy   = false
}