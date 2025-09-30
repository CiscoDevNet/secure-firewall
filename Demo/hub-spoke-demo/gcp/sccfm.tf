################################################################################
# Access Control Policy
################################################################################

resource "fmc_access_control_policy" "egress-policy" {
  name                              = "GCP-Egress-Firewall Policy"
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
  name                              = "GCP-Ingress-Firewall Policy"
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
  name                              = "GCP-EastWest-Firewall Policy"
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
  name               = "GCP-Egress-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.egress-policy.name
}
resource "sccfm_ftd_device" "ingress-fw" {
  name               = "GCP-Ingress-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.ingress-policy.name
}
resource "sccfm_ftd_device" "eastwest-fw" {
  name               = "GCP-EastWest-Firewall"
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
    # GCP Compute Instances
    google_compute_instance.ftdv_egress,
    google_compute_instance.ftdv_ingress,
    google_compute_instance.ftdv_eastwest,
    google_compute_instance.spoke1_vm,
    google_compute_instance.spoke2_vm,

    # VPC Peering Infrastructure
    # google_compute_network_peering.inside_to_spoke1,
    # google_compute_network_peering.spoke1_to_inside,
    # google_compute_network_peering.inside_to_spoke2,
    # google_compute_network_peering.spoke2_to_inside,

    # Multi-VPC Infrastructure
    google_compute_network.inside_vpc,
    google_compute_network.outside_vpc,
    google_compute_network.management_vpc,
    google_compute_network.diagnostic_vpc,
    google_compute_subnetwork.management,
    google_compute_subnetwork.diagnostic,
    google_compute_subnetwork.outside,
    google_compute_subnetwork.inside,

    # Spoke VPC Infrastructure
    google_compute_network.spoke1_vpc,
    google_compute_network.spoke2_vpc,
    google_compute_subnetwork.spoke1_private,
    google_compute_subnetwork.spoke2_private,

    # Firewall Rules - Management VPC
    google_compute_firewall.management_ingress,
    google_compute_firewall.management_egress,
    
    # Firewall Rules - Diagnostic VPC
    google_compute_firewall.diagnostic_ingress,
    google_compute_firewall.diagnostic_egress,
    
    # Firewall Rules - Outside VPC
    google_compute_firewall.outside_ingress,
    google_compute_firewall.outside_egress,
    
    # Firewall Rules - Inside VPC
    google_compute_firewall.inside_ingress,
    google_compute_firewall.inside_egress,
    
    # Firewall Rules - Spoke VPCs
    google_compute_firewall.spoke1_ingress,
    google_compute_firewall.spoke1_egress,
    google_compute_firewall.spoke2_ingress,
    google_compute_firewall.spoke2_egress,

    # Routes
    google_compute_route.outside_default,
    # google_compute_route.inside_to_spoke1,  # Commented out to fix routing loops
    # google_compute_route.inside_to_spoke2,

    # FMC Device Creation
    sccfm_ftd_device.egress-fw,
    sccfm_ftd_device.ingress-fw,
    sccfm_ftd_device.eastwest-fw
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
# Data Sources
################################################################################
data "fmc_device" "eastwest-fw" {
  depends_on = [time_sleep.twomin]
  name       = "GCP-EastWest-Firewall"
}
data "fmc_device" "egress-fw" {
  depends_on = [time_sleep.twomin]
  name       = "GCP-Egress-Firewall"
}
data "fmc_device" "ingress-fw" {
  depends_on = [time_sleep.twomin]
  name       = "GCP-Ingress-Firewall"
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
  name           = "gcp-outside"
  interface_type = "ROUTED"
}
resource "fmc_security_zone" "inside" {
  depends_on     = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name           = "gcp-inside"
  interface_type = "ROUTED"
}
resource "fmc_host" "int_gw" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "gcp-internet-gw"
  ip         = "10.0.2.1"
}

resource "fmc_host" "inside_gw" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "gcp-inside-gw"
  ip         = "10.0.3.1"
}
resource "fmc_host" "spoke1_ip" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "GCP-Spoke1-IP"
  ip         = google_compute_instance.spoke1_vm.network_interface[0].network_ip
}
resource "fmc_host" "spoke2_ip" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "GCP-Spoke2-IP"
  ip         = google_compute_instance.spoke2_vm.network_interface[0].network_ip
}
resource "fmc_network" "spoke1_vpc" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "GCP-Spoke1-VPC"
  prefix     = var.spoke1_vpc_cidr
}
resource "fmc_network" "spoke2_vpc" {
  depends_on = [data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4]
  name       = "GCP-Spoke2-VPC"
  prefix     = var.spoke2_vpc_cidr
}

################################################################################################
# Nat Policy
################################################################################################
resource "fmc_ftd_nat_policy" "egress-nat" {
  name        = "GCP-Egress-NAT"
  description = "Created by Terraform"
  auto_nat_rules = [
    {
      nat_type                             = "STATIC"
      source_interface_id                  = fmc_security_zone.inside.id
      destination_interface_id             = fmc_security_zone.outside.id
      original_network_id                  = fmc_network.spoke1_vpc.id
      translated_network_is_destination_interface = true
    },
    {
      nat_type                             = "STATIC"
      source_interface_id                  = fmc_security_zone.inside.id
      destination_interface_id             = fmc_security_zone.outside.id
      original_network_id                  = fmc_network.spoke2_vpc.id
      translated_network_is_destination_interface = true
    }
  ]
}
resource "fmc_ftd_nat_policy" "ingress-nat" {
  name        = "GCP-Ingress-NAT"
  description = "Created by automation"
  manual_nat_rules = [
    {
      enabled                          = true
      section                          = "BEFORE_AUTO"
      nat_type                         = "DYNAMIC"
      source_interface_id              = fmc_security_zone.outside.id
      destination_interface_id         = fmc_security_zone.inside.id
      original_source_id               = data.fmc_network.any_ipv4.id
      interface_in_original_destination = true
      interface_in_translated_source   = true
      translated_destination_id        = fmc_host.spoke1_ip.id
      unidirectional                   = true
    },
  ]
}
resource "fmc_ftd_nat_policy" "eastwest-nat" {
  name        = "GCP-EastWest-NAT"
  description = "Created by automation"
}

################################################################################################
# Configuring physical interfaces
################################################################################################
# Egress
resource "fmc_device_physical_interface" "egress_00" {
  device_id                  = data.fmc_device.egress-fw.id
  logical_name               = "gcp-outside"
  mode                       = "NONE"
  security_zone_id           = fmc_security_zone.outside.id
  name                       = "GigabitEthernet0/0"
  mtu                        = 1500
  ipv4_dhcp_obtain_route     = true
  ipv4_dhcp_route_metric     = 1
}
resource "fmc_device_physical_interface" "egress_01" {
  device_id                  = data.fmc_device.egress-fw.id
  logical_name               = "gcp-inside"
  mode                       = "NONE"
  security_zone_id           = fmc_security_zone.inside.id
  name                       = "GigabitEthernet0/1"
  mtu                        = 1500
  ipv4_dhcp_obtain_route     = true
  ipv4_dhcp_route_metric     = 1
}

# Ingress
resource "fmc_device_physical_interface" "ingress_00" {
  device_id                  = data.fmc_device.ingress-fw.id
  logical_name               = "gcp-outside"
  mode                       = "NONE"
  security_zone_id           = fmc_security_zone.outside.id
  name                       = "GigabitEthernet0/0"
  mtu                        = 1500
  ipv4_dhcp_obtain_route     = true
  ipv4_dhcp_route_metric     = 1
}
resource "fmc_device_physical_interface" "ingress_01" {
  device_id                  = data.fmc_device.ingress-fw.id
  logical_name               = "gcp-inside"
  mode                       = "NONE"
  security_zone_id           = fmc_security_zone.inside.id
  name                       = "GigabitEthernet0/1"
  mtu                        = 1500
  ipv4_dhcp_obtain_route     = true
  ipv4_dhcp_route_metric     = 1
}

# EastWest
resource "fmc_device_physical_interface" "eastwest_00" {
  device_id                  = data.fmc_device.eastwest-fw.id
  logical_name               = "gcp-outside"
  mode                       = "NONE"
  security_zone_id           = fmc_security_zone.outside.id
  name                       = "GigabitEthernet0/0"
  mtu                        = 1500
  ipv4_dhcp_obtain_route     = true
  ipv4_dhcp_route_metric     = 1
}
resource "fmc_device_physical_interface" "eastwest_01" {
  device_id                  = data.fmc_device.eastwest-fw.id
  logical_name               = "gcp-inside"
  mode                       = "NONE"
  security_zone_id           = fmc_security_zone.inside.id
  name                       = "GigabitEthernet0/1"
  mtu                        = 1500
  ipv4_dhcp_obtain_route     = true
  ipv4_dhcp_route_metric     = 1
}

################################################################################
# Static Routes
################################################################################
# Egress - Default route for internet traffic
resource "fmc_device_ipv4_static_route" "egress_sr" {
  device_id              = data.fmc_device.egress-fw.id
  interface_logical_name = "gcp-outside"
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
  interface_logical_name = "gcp-inside"
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
  interface_logical_name = "gcp-inside"
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
  interface_logical_name = "gcp-outside"
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
  interface_logical_name = "gcp-inside"
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
  interface_logical_name = "gcp-inside"
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
  interface_logical_name = "gcp-inside"
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