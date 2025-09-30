################################################################################
# Access Control Policy
################################################################################

resource "fmc_access_control_policy" "egress-policy" {
  name                              = "Azure-Egress-Firewall Policy"
  description                       = "Created via terraform"
  default_action                    = "BLOCK"
  default_action_log_end            = true
  default_action_send_events_to_fmc = true

  manage_rules = true
  rules = [
    {
      action             = "ALLOW"
      name               = "allow-all"
      log_end            = true
      send_events_to_fmc = true
      section            = "mandatory"
    }
  ]
}

resource "fmc_access_control_policy" "ingress-policy" {
  name                              = "Azure-Ingress-Firewall Policy"
  description                       = "Created via terraform"
  default_action                    = "BLOCK"
  default_action_log_end            = true
  default_action_send_events_to_fmc = true

  manage_rules = true
  rules = [
    {
      action             = "ALLOW"
      name               = "allow-all"
      log_end            = true
      send_events_to_fmc = true
      section            = "mandatory"
    }
  ]
}

resource "fmc_access_control_policy" "eastwest-policy" {
  name                              = "Azure-EastWest-Firewall Policy"
  description                       = "Created via terraform"
  default_action                    = "BLOCK"
  default_action_log_end            = true
  default_action_send_events_to_fmc = true

  manage_rules = true
  rules = [
    {
      action             = "ALLOW"
      name               = "allow-all"
      log_end            = true
      send_events_to_fmc = true
      section            = "mandatory"
    }
  ]
}

################################################################################
# Device Creation
################################################################################
resource "sccfm_ftd_device" "egress-fw" {
  name               = "Azure-Egress-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.egress-policy.name
}
resource "sccfm_ftd_device" "ingress-fw" {
  name               = "Azure-Ingress-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.ingress-policy.name
}
resource "sccfm_ftd_device" "eastwest-fw" {
  name               = "Azure-EastWest-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.eastwest-policy.name
}
################################################################################
# Device Onboarding
################################################################################
resource "time_sleep" "wait" {
  depends_on = [
    # VNet Peering Infrastructure
    azurerm_virtual_network_peering.security_to_spoke1,
    azurerm_virtual_network_peering.spoke1_to_security,
    azurerm_virtual_network_peering.security_to_spoke2,
    azurerm_virtual_network_peering.spoke2_to_security,

    # Security VNet Infrastructure
    azurerm_network_security_group.management,
    azurerm_network_security_group.outside,
    azurerm_network_security_group.inside,
    azurerm_subnet_network_security_group_association.management,
    azurerm_subnet_network_security_group_association.outside,
    azurerm_subnet_network_security_group_association.inside,
    azurerm_route_table.outside,
    azurerm_route_table.inside,
    azurerm_subnet_route_table_association.outside,
    azurerm_subnet_route_table_association.inside,

    # Spoke VNets Infrastructure
    azurerm_network_security_group.spoke_private,
    azurerm_network_security_group.spoke2_private,
    azurerm_subnet_network_security_group_association.spoke1_private,
    azurerm_subnet_network_security_group_association.spoke2_private,
    azurerm_route_table.spoke1,
    azurerm_route_table.spoke2,
    azurerm_subnet_route_table_association.spoke1_private,
    azurerm_subnet_route_table_association.spoke2_private,

    # FTDv Public IPs
    azurerm_public_ip.ftdv_egress_mgmt,
    azurerm_public_ip.ftdv_ingress_mgmt,
    azurerm_public_ip.ftdv_eastwest_mgmt,
    azurerm_public_ip.ftdv_egress_outside,
    azurerm_public_ip.ftdv_ingress_outside,
    azurerm_public_ip.ftdv_eastwest_outside,


    # FTDv Virtual Machines
    azurerm_virtual_machine.ftdv_egress,
    azurerm_virtual_machine.ftdv_ingress,
    azurerm_virtual_machine.ftdv_eastwest,

    # Spoke Test VMs Infrastructure
    azurerm_network_interface.spoke1_vm,
    azurerm_network_interface.spoke2_vm,
    azurerm_linux_virtual_machine.spoke1,
    azurerm_linux_virtual_machine.spoke2
  ]
  create_duration = "15m"
}

resource "sccfm_ftd_device_onboarding" "egress-fw" {
  depends_on = [
    time_sleep.wait
  ]
  ftd_uid = sccfm_ftd_device.egress-fw.id
}

resource "sccfm_ftd_device_onboarding" "ingress-fw" {
  depends_on = [
    sccfm_ftd_device_onboarding.egress-fw
  ]
  ftd_uid = sccfm_ftd_device.ingress-fw.id
}

resource "sccfm_ftd_device_onboarding" "eastwest-fw" {
  depends_on = [
    sccfm_ftd_device_onboarding.ingress-fw
  ]
  ftd_uid = sccfm_ftd_device.eastwest-fw.id
}

resource "time_sleep" "twomin" {
  depends_on = [
    sccfm_ftd_device_onboarding.egress-fw,
    sccfm_ftd_device_onboarding.ingress-fw,
    sccfm_ftd_device_onboarding.eastwest-fw
  ]
  create_duration = "2m"
}
################################################################################
data "fmc_device" "eastwest-fw" {
  depends_on = [time_sleep.twomin]
  name       = "Azure-EastWest-Firewall"
}
data "fmc_device" "egress-fw" {
  depends_on = [time_sleep.twomin]
  name       = "Azure-Egress-Firewall"
}
data "fmc_device" "ingress-fw" {
  depends_on = [time_sleep.twomin]
  name       = "Azure-Ingress-Firewall"
}
data "fmc_network" "any_ipv4" {
  depends_on = [time_sleep.twomin]
  name       = "any-ipv4"
}

################################################################################
# Objects
################################################################################
resource "fmc_security_zone" "outside" {
  depends_on     = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name           = "az-outside"
  interface_type = "ROUTED"
}
resource "fmc_security_zone" "inside" {
  depends_on     = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name           = "az-inside"
  interface_type = "ROUTED"
}
resource "fmc_host" "int_gw" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "az-outside-gw"
  ip         = "10.0.2.1"
}

resource "fmc_host" "inside_gw" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "az-inside-gw"
  ip         = "10.0.3.1"
}
resource "fmc_host" "spoke1_ip" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "Azure-Spoke1-IP"
  ip         = azurerm_network_interface.spoke1_vm.private_ip_address
}
resource "fmc_host" "spoke2_ip" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "Azure-Spoke2-IP"
  ip         = azurerm_network_interface.spoke2_vm.private_ip_address
}
resource "fmc_network" "spoke1_vpc" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "Azure-Spoke1-VNet"
  prefix     = var.spoke1_vnet_cidr
}
resource "fmc_network" "spoke2_vpc" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "Azure-Spoke2-VNet"
  prefix     = var.spoke2_vnet_cidr
}
################################################################################################
# Nat Policy
################################################################################################
resource "fmc_ftd_nat_policy" "egress-nat" {
  name        = "Azure-Egress-NAT"
  description = "Created by Terraform"
  auto_nat_rules = [
    {
      nat_type                 = "STATIC"
      source_interface_id      = fmc_security_zone.inside.id
      destination_interface_id = fmc_security_zone.outside.id

      original_network_id                         = fmc_network.spoke1_vpc.id
      translated_network_is_destination_interface = true
    },
    {
      nat_type                 = "STATIC"
      source_interface_id      = fmc_security_zone.inside.id
      destination_interface_id = fmc_security_zone.outside.id

      original_network_id                         = fmc_network.spoke2_vpc.id
      translated_network_is_destination_interface = true
    }
  ]
}
resource "fmc_ftd_nat_policy" "ingress-nat" {
  name        = "Azure-Ingress-NAT"
  description = "Created by automation"
  manual_nat_rules = [
    {
      enabled                  = true
      section                  = "BEFORE_AUTO"
      nat_type                 = "DYNAMIC"
      source_interface_id      = fmc_security_zone.outside.id
      destination_interface_id = fmc_security_zone.inside.id

      original_source_id                = data.fmc_network.any_ipv4.id
      interface_in_original_destination = true

      interface_in_translated_source = true
      translated_destination_id      = fmc_host.spoke1_ip.id
      unidirectional                 = true
    },
  ]
}
resource "fmc_ftd_nat_policy" "eastwest-nat" {
  name        = "Azure-EastWest-NAT"
  description = "Created by automation"
}
################################################################################################
# Configuring physical interfaces
################################################################################################
# Egress
resource "fmc_device_physical_interface" "egress_00" {
  device_id              = data.fmc_device.egress-fw.id
  logical_name           = "az-outside"
  mode                   = "NONE"
  security_zone_id       = fmc_security_zone.outside.id
  name                   = "GigabitEthernet0/0"
  mtu                    = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interface" "egress_01" {
  device_id              = data.fmc_device.egress-fw.id
  logical_name           = "az-inside"
  mode                   = "NONE"
  security_zone_id       = fmc_security_zone.inside.id
  name                   = "GigabitEthernet0/1"
  mtu                    = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}

# Ingress
resource "fmc_device_physical_interface" "ingress_00" {
  device_id              = data.fmc_device.ingress-fw.id
  logical_name           = "az-outside"
  mode                   = "NONE"
  security_zone_id       = fmc_security_zone.outside.id
  name                   = "GigabitEthernet0/0"
  mtu                    = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interface" "ingress_01" {
  device_id              = data.fmc_device.ingress-fw.id
  logical_name           = "az-inside"
  mode                   = "NONE"
  security_zone_id       = fmc_security_zone.inside.id
  name                   = "GigabitEthernet0/1"
  mtu                    = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}


# EastWest
resource "fmc_device_physical_interface" "eastwest_00" {
  device_id              = data.fmc_device.eastwest-fw.id
  logical_name           = "az-outside"
  mode                   = "NONE"
  security_zone_id       = fmc_security_zone.outside.id
  name                   = "GigabitEthernet0/0"
  mtu                    = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interface" "eastwest_01" {
  device_id              = data.fmc_device.eastwest-fw.id
  logical_name           = "az-inside"
  mode                   = "NONE"
  security_zone_id       = fmc_security_zone.inside.id
  name                   = "GigabitEthernet0/1"
  mtu                    = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
################################################################################
#Static Routes
################################################################################
# Egress - Default route for internet traffic
resource "fmc_device_ipv4_static_route" "egress_sr" {
  device_id              = data.fmc_device.egress-fw.id
  interface_logical_name = "az-outside"
  interface_id           = fmc_device_physical_interface.egress_00.id
  destination_networks = [
    {
      id = data.fmc_network.any_ipv4.id
    }
  ]
  metric_value           = 1
  gateway_host_object_id = fmc_host.int_gw.id
}

# Egress - Routes to spoke networks via inside interface
resource "fmc_device_ipv4_static_route" "egress_to_spoke1" {
  device_id              = data.fmc_device.egress-fw.id
  interface_logical_name = "az-inside"
  interface_id           = fmc_device_physical_interface.egress_01.id
  destination_networks = [
    {
      id = fmc_network.spoke1_vpc.id
    }
  ]
  metric_value           = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}

resource "fmc_device_ipv4_static_route" "egress_to_spoke2" {
  device_id              = data.fmc_device.egress-fw.id
  interface_logical_name = "az-inside"
  interface_id           = fmc_device_physical_interface.egress_01.id
  destination_networks = [
    {
      id = fmc_network.spoke2_vpc.id
    }
  ]
  metric_value           = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}
# Ingress
resource "fmc_device_ipv4_static_route" "ingress_sr" {
  device_id              = data.fmc_device.ingress-fw.id
  interface_logical_name = "az-outside"
  interface_id           = fmc_device_physical_interface.ingress_00.id
  destination_networks = [
    {
      id = data.fmc_network.any_ipv4.id
    }
  ]
  metric_value           = 1
  gateway_host_object_id = fmc_host.int_gw.id
}
resource "fmc_device_ipv4_static_route" "ingress_sr2" {
  device_id              = data.fmc_device.ingress-fw.id
  interface_logical_name = "az-inside"
  interface_id           = fmc_device_physical_interface.ingress_01.id
  destination_networks = [
    {
      id = fmc_network.spoke1_vpc.id
    },
    {
      id = fmc_network.spoke2_vpc.id
    }
  ]
  metric_value           = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}
# EastWest - Static routes for inter-spoke traffic
resource "fmc_device_ipv4_static_route" "eastwest_to_spoke1" {
  device_id              = data.fmc_device.eastwest-fw.id
  interface_logical_name = "az-inside"
  interface_id           = fmc_device_physical_interface.eastwest_01.id
  destination_networks = [
    {
      id = fmc_network.spoke1_vpc.id
    }
  ]
  metric_value           = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}

resource "fmc_device_ipv4_static_route" "eastwest_to_spoke2" {
  device_id              = data.fmc_device.eastwest-fw.id
  interface_logical_name = "az-inside"
  interface_id           = fmc_device_physical_interface.eastwest_01.id
  destination_networks = [
    {
      id = fmc_network.spoke2_vpc.id
    }
  ]
  metric_value           = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}

################################################################################################
# Attaching NAT Policy to device
################################################################################################
resource "fmc_policy_assignment" "egress_nat_attach" {
  policy_id   = fmc_ftd_nat_policy.egress-nat.id
  policy_type = "FTDNatPolicy"
  targets = [
    {
      id   = data.fmc_device.egress-fw.id
      type = "Device"
      name = data.fmc_device.egress-fw.name
    }
  ]
}
resource "fmc_policy_assignment" "ingress_nat_attach" {
  policy_id   = fmc_ftd_nat_policy.ingress-nat.id
  policy_type = "FTDNatPolicy"
  targets = [
    {
      id   = data.fmc_device.ingress-fw.id
      type = "Device"
      name = data.fmc_device.ingress-fw.name
    }
  ]
}
resource "fmc_policy_assignment" "eastwest_nat_attach" {
  policy_id   = fmc_ftd_nat_policy.eastwest-nat.id
  policy_type = "FTDNatPolicy"
  targets = [
    {
      id   = data.fmc_device.eastwest-fw.id
      type = "Device"
      name = data.fmc_device.eastwest-fw.name
    }
  ]
}
################################################################################################
# Deploying the changes to the device
################################################################################################
resource "fmc_device_deploy" "deploy" {
  depends_on = [
    fmc_policy_assignment.egress_nat_attach,
    fmc_policy_assignment.ingress_nat_attach,
    fmc_policy_assignment.eastwest_nat_attach,
    fmc_device_ipv4_static_route.egress_sr,
    fmc_device_ipv4_static_route.ingress_sr,
    fmc_device_ipv4_static_route.ingress_sr2,
    fmc_device_ipv4_static_route.egress_to_spoke1,
    fmc_device_ipv4_static_route.egress_to_spoke2,
    fmc_device_ipv4_static_route.eastwest_to_spoke1,
    fmc_device_ipv4_static_route.eastwest_to_spoke2
  ]
  ignore_warning  = true
  device_id_list  = [data.fmc_device.egress-fw.id, data.fmc_device.ingress-fw.id, data.fmc_device.eastwest-fw.id]
  deployment_note = "Terraform initiated deployment"
}
