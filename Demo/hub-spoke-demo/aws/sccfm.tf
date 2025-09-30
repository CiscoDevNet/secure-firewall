################################################################################
# Access Control Policy
################################################################################

resource "fmc_access_control_policy" "egress-policy" {
  name                              = "AWS-Egress-Firewall Policy"
  description                       = "Created via terraform"
  default_action                    = "BLOCK"
  default_action_log_end            = true
  default_action_send_events_to_fmc = true

  manage_rules = true
  rules = [
    {
      action = "ALLOW"
      name   = "allow-all"
      log_end             = true
      send_events_to_fmc  = true
      section = "mandatory"
    }
  ]
}

resource "fmc_access_control_policy" "ingress-policy" {
  name                              = "AWS-Ingress-Firewall Policy"
  description                       = "Created via terraform"
  default_action                    = "BLOCK"
  default_action_log_end            = true
  default_action_send_events_to_fmc = true

  manage_rules = true
  rules = [
    {
      action = "ALLOW"
      name   = "allow-all"
      log_end             = true
      send_events_to_fmc  = true
      section = "mandatory"
    }
  ]
}

resource "fmc_access_control_policy" "eastwest-policy" {
  name                              = "AWS-EastWest-Firewall Policy"
  description                       = "Created via terraform"
  default_action                    = "BLOCK"
  default_action_log_end            = true
  default_action_send_events_to_fmc = true

  manage_rules = true
  rules = [
    {
      action = "ALLOW"
      name   = "allow-all"
      log_end             = true
      send_events_to_fmc  = true
      section = "mandatory"
    }
  ]
}

################################################################################
# Device Creation
################################################################################
resource "sccfm_ftd_device" "engress-fw" {
  name               = "AWS-Egress-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.egress-policy.name
}
resource "sccfm_ftd_device" "ingress-fw" {
  name               = "AWS-Ingress-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.ingress-policy.name
}
resource "sccfm_ftd_device" "eastwest-fw" {
  name               = "AWS-EastWest-Firewall"
  licenses           = ["BASE", "MALWARE", "THREAT", "URLFilter"]
  virtual            = true
  performance_tier   = "FTDv10"
  access_policy_name = fmc_access_control_policy.eastwest-policy.name
}
################################################################################
# Device Onboarding
################################################################################
resource "time_sleep" "wait" {
  depends_on      = [
    # EC2 Instances
    aws_instance.egress_ftdv, 
    aws_instance.ingress_ftdv, 
    aws_instance.eastwest_ftdv,
    aws_instance.ubuntu_spoke1,
    aws_instance.ubuntu_spoke2,
    
    # Elastic IPs
    aws_eip.egress_mgmt_eip,
    aws_eip.ingress_mgmt_eip,
    aws_eip.eastwest_mgmt_eip,
    aws_eip.egress_outside_eip,
    aws_eip.ingress_outside_eip,
    aws_eip.eastwest_outside_eip,
    
    # Network Interface Attachments
    aws_network_interface_attachment.egress_diag_attachment,
    aws_network_interface_attachment.egress_outside_attachment,
    aws_network_interface_attachment.egress_inside_attachment,
    aws_network_interface_attachment.ingress_diag_attachment,
    aws_network_interface_attachment.ingress_outside_attachment,
    aws_network_interface_attachment.ingress_inside_attachment,
    aws_network_interface_attachment.eastwest_diag_attachment,
    aws_network_interface_attachment.eastwest_outside_attachment,
    aws_network_interface_attachment.eastwest_inside_attachment,
    
    # Transit Gateway and Attachments
    aws_ec2_transit_gateway.main_tgw,
    aws_ec2_transit_gateway_vpc_attachment.security_vpc_attachment,
    aws_ec2_transit_gateway_vpc_attachment.spoke1_vpc_attachment,
    aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_attachment,
    
    # Transit Gateway Route Tables and Routes
    aws_ec2_transit_gateway_route_table.security_rt,
    aws_ec2_transit_gateway_route_table.spoke1_rt,
    aws_ec2_transit_gateway_route_table.spoke2_rt,
    aws_ec2_transit_gateway_route_table_association.security_vpc_association,
    aws_ec2_transit_gateway_route_table_association.spoke1_vpc_association,
    aws_ec2_transit_gateway_route_table_association.spoke2_vpc_association,
    aws_ec2_transit_gateway_route.security_to_spoke1,
    aws_ec2_transit_gateway_route.security_to_spoke2,
    aws_ec2_transit_gateway_route.spoke1_to_security,
    aws_ec2_transit_gateway_route.spoke2_to_security,
    aws_ec2_transit_gateway_route.spoke1_to_spoke2_via_security,
    aws_ec2_transit_gateway_route.spoke2_to_spoke1_via_security,
    aws_ec2_transit_gateway_route.spoke1_default_to_security,
    aws_ec2_transit_gateway_route.spoke2_default_to_security,
    
    # Route Tables and Routes
    aws_route_table.management_rt,
    aws_route_table.outside_rt,
    aws_route_table.security_private_rt,
    aws_route_table.tgw_rt,
    aws_route_table.spoke1_private_rt,
    aws_route_table.spoke2_private_rt,
    aws_route.security_private_to_spoke1,
    aws_route.security_private_to_spoke2,
    aws_route.tgw_to_egress,
    aws_route.tgw_spoke1_to_eastwest,
    aws_route.tgw_spoke2_to_eastwest,
    aws_route.spoke1_to_spoke2,
    aws_route.spoke1_to_security,
    aws_route.spoke1_default,
    aws_route.spoke2_to_spoke1,
    aws_route.spoke2_to_security,
    aws_route.spoke2_default,
    
    # Route Table Associations
    aws_route_table_association.management_association,
    aws_route_table_association.outside_association,
    aws_route_table_association.inside_private,
    aws_route_table_association.spoke1_private,
    aws_route_table_association.spoke2_private,
    
    # FMC Device Creation
    sccfm_ftd_device.engress-fw,
    sccfm_ftd_device.ingress-fw,
    sccfm_ftd_device.eastwest-fw
  ]
  create_duration = "15m"
}

resource "sccfm_ftd_device_onboarding" "egress-fw" {
  depends_on = [ 
    time_sleep.wait
  ]
  ftd_uid    = sccfm_ftd_device.engress-fw.id
}

resource "sccfm_ftd_device_onboarding" "ingress-fw" {
  depends_on = [ 
    sccfm_ftd_device_onboarding.egress-fw
  ]
  ftd_uid    = sccfm_ftd_device.ingress-fw.id
}

resource "sccfm_ftd_device_onboarding" "eastwest-fw" {
  depends_on = [
    sccfm_ftd_device_onboarding.ingress-fw
  ]
  ftd_uid    = sccfm_ftd_device.eastwest-fw.id
}

resource "time_sleep" "twomin" {
  depends_on      = [
    sccfm_ftd_device_onboarding.egress-fw,
    sccfm_ftd_device_onboarding.ingress-fw,
    sccfm_ftd_device_onboarding.eastwest-fw
  ]
  create_duration = "2m"
}
################################################################################
data "fmc_device" "eastwest-fw" {
  depends_on = [time_sleep.twomin]
  name       = "AWS-EastWest-Firewall"
}
data "fmc_device" "egress-fw" {
  depends_on = [time_sleep.twomin]
  name       = "AWS-Egress-Firewall"
}
data "fmc_device" "ingress-fw" {
  depends_on = [time_sleep.twomin]
  name       = "AWS-Ingress-Firewall"
}
data "fmc_network" "any_ipv4" {
  depends_on = [time_sleep.twomin]
  name       = "any-ipv4"
}
################################################################################
# Objects
################################################################################
resource "fmc_security_zone" "outside" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "outside"
  interface_type = "ROUTED"
}
resource "fmc_security_zone" "inside" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "inside"
  interface_type = "ROUTED"
}
resource "fmc_host" "int_gw" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "internet-gw"
  ip = "10.0.2.1"
}

resource "fmc_host" "inside_gw" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "inside-gw"
  ip = "10.0.3.1"
}
resource "fmc_host" "spoke1_ip" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "AWS-Spoke1-IP"
  ip         = aws_instance.ubuntu_spoke1.private_ip
}
resource "fmc_host" "spoke2_ip" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "AWS-Spoke2-IP"
  ip         = aws_instance.ubuntu_spoke2.private_ip
}
resource "fmc_network" "spoke1_vpc" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "AWS-Spoke1-VPC"
  prefix      = "${var.spoke1_vpc_cidr}"
}
resource "fmc_network" "spoke2_vpc" {
  depends_on = [ data.fmc_device.egress-fw, data.fmc_device.ingress-fw, data.fmc_device.eastwest-fw, data.fmc_network.any_ipv4 ]
  name       = "AWS-Spoke2-VPC"
  prefix      = "${var.spoke2_vpc_cidr}"
}
################################################################################################
# Nat Policy
################################################################################################
resource "fmc_ftd_nat_policy" "egress-nat" {
  name        = "AWS-Egress-NAT"
  description = "Created by Terraform"
  auto_nat_rules = [
    {
      nat_type              = "STATIC"
      source_interface_id = fmc_security_zone.inside.id
      destination_interface_id = fmc_security_zone.outside.id

      original_network_id   = fmc_network.spoke1_vpc.id
      translated_network_is_destination_interface = true
    },
    {
      nat_type              = "STATIC"
      source_interface_id = fmc_security_zone.inside.id
      destination_interface_id = fmc_security_zone.outside.id

      original_network_id   = fmc_network.spoke2_vpc.id
      translated_network_is_destination_interface = true
    }
  ]
}
resource "fmc_ftd_nat_policy" "ingress-nat" {
  name        = "AWS-Ingress-NAT"
  description = "Created by automation"
  manual_nat_rules = [
    {
      enabled              = true
      section              = "BEFORE_AUTO"
      nat_type             = "DYNAMIC"
      source_interface_id = fmc_security_zone.outside.id
      destination_interface_id = fmc_security_zone.inside.id
      
      original_source_id   = data.fmc_network.any_ipv4.id
      interface_in_original_destination = true
      
      interface_in_translated_source = true
      translated_destination_id = fmc_host.spoke1_ip.id
      unidirectional = true
    },
  ]
}
resource "fmc_ftd_nat_policy" "eastwest-nat" {
  name        = "AWS-EastWest-NAT"
  description = "Created by automation"
}
################################################################################################
# Configuring physical interfaces
################################################################################################
# Egress
resource "fmc_device_physical_interface" "egress_00" {
  device_id            = data.fmc_device.egress-fw.id
  logical_name         = "outside"
  mode                 = "NONE"
  security_zone_id     = fmc_security_zone.outside.id
  name                 = "TenGigabitEthernet0/0"
  mtu                  = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interface" "egress_01" {
  device_id            = data.fmc_device.egress-fw.id
  logical_name         = "inside"
  mode                 = "NONE"
  security_zone_id     = fmc_security_zone.inside.id
  name                 = "TenGigabitEthernet0/1"
  mtu                  = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}

# Ingress
resource "fmc_device_physical_interface" "ingress_00" {
  device_id            = data.fmc_device.ingress-fw.id
  logical_name         = "outside"
  mode                 = "NONE"
  security_zone_id     = fmc_security_zone.outside.id
  name                 = "TenGigabitEthernet0/0"
  mtu                  = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interface" "ingress_01" {
  device_id            = data.fmc_device.ingress-fw.id
  logical_name         = "inside"
  mode                 = "NONE"
  security_zone_id     = fmc_security_zone.inside.id
  name                 = "TenGigabitEthernet0/1"
  mtu                  = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}


# EastWest
resource "fmc_device_physical_interface" "eastwest_00" {
  device_id            = data.fmc_device.eastwest-fw.id
  logical_name         = "outside"
  mode                 = "NONE"
  security_zone_id     = fmc_security_zone.outside.id
  name                 = "TenGigabitEthernet0/0"
  mtu                  = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interface" "eastwest_01" {
  device_id            = data.fmc_device.eastwest-fw.id
  logical_name         = "inside"
  mode                 = "NONE"
  security_zone_id     = fmc_security_zone.inside.id
  name                 = "TenGigabitEthernet0/1"
  mtu                  = 1500
  ipv4_dhcp_obtain_route = true
  ipv4_dhcp_route_metric = 1
}
################################################################################
#Static Routes
################################################################################
# Egress - Default route for internet traffic
resource "fmc_device_ipv4_static_route" "egress_sr" {
  device_id              = data.fmc_device.egress-fw.id
  interface_logical_name = "outside"
  interface_id           = fmc_device_physical_interface.egress_00.id
  destination_networks = [
    {
      id = data.fmc_network.any_ipv4.id
    }
  ]
  metric_value         = 1
  gateway_host_object_id = fmc_host.int_gw.id
}

# Egress - Routes to spoke networks via inside interface
resource "fmc_device_ipv4_static_route" "egress_to_spoke1" {
  device_id              = data.fmc_device.egress-fw.id
  interface_logical_name = "inside"
  interface_id           = fmc_device_physical_interface.egress_01.id
  destination_networks = [
    {
      id = fmc_network.spoke1_vpc.id
    }
  ]
  metric_value = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}

resource "fmc_device_ipv4_static_route" "egress_to_spoke2" {
  device_id              = data.fmc_device.egress-fw.id
  interface_logical_name = "inside"
  interface_id           = fmc_device_physical_interface.egress_01.id
  destination_networks = [
    {
      id = fmc_network.spoke2_vpc.id
    }
  ]
  metric_value = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}
# Ingress
resource "fmc_device_ipv4_static_route" "ingress_sr" {
  device_id              = data.fmc_device.ingress-fw.id
  interface_logical_name = "outside"
  interface_id           = fmc_device_physical_interface.ingress_00.id
  destination_networks = [
    {
      id = data.fmc_network.any_ipv4.id
    }
  ]
  metric_value         = 1
  gateway_host_object_id = fmc_host.int_gw.id
}
resource "fmc_device_ipv4_static_route" "ingress_sr2" {
  device_id              = data.fmc_device.ingress-fw.id
  interface_logical_name = "inside"
  interface_id           = fmc_device_physical_interface.ingress_01.id
  destination_networks = [
    {
      id = fmc_network.spoke1_vpc.id
    },
    {
      id = fmc_network.spoke2_vpc.id
    }
  ]
  metric_value         = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}
# EastWest - Static routes for inter-spoke traffic
resource "fmc_device_ipv4_static_route" "eastwest_to_spoke1" {
  device_id              = data.fmc_device.eastwest-fw.id
  interface_logical_name = "inside"
  interface_id           = fmc_device_physical_interface.eastwest_01.id
  destination_networks = [
    {
      id = fmc_network.spoke1_vpc.id
    }
  ]
  metric_value         = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}

resource "fmc_device_ipv4_static_route" "eastwest_to_spoke2" {
  device_id              = data.fmc_device.eastwest-fw.id
  interface_logical_name = "inside"
  interface_id           = fmc_device_physical_interface.eastwest_01.id
  destination_networks = [
    {
      id = fmc_network.spoke2_vpc.id
    }
  ]
  metric_value         = 1
  gateway_host_object_id = fmc_host.inside_gw.id
}

################################################################################################
# Attaching NAT Policy to device
################################################################################################
resource "fmc_policy_assignment" "egress_nat_attach" {
  policy_id               = fmc_ftd_nat_policy.egress-nat.id
  policy_type             = "FTDNatPolicy"
  targets = [
    {
      id   = data.fmc_device.egress-fw.id
      type = "Device"
      name = data.fmc_device.egress-fw.name
    }
  ]
}
resource "fmc_policy_assignment" "ingress_nat_attach" {
  policy_id               = fmc_ftd_nat_policy.ingress-nat.id
  policy_type             = "FTDNatPolicy"
  targets = [
    {
      id   = data.fmc_device.ingress-fw.id
      type = "Device"
      name = data.fmc_device.ingress-fw.name
    }
  ]
}
resource "fmc_policy_assignment" "eastwest_nat_attach" {
  policy_id               = fmc_ftd_nat_policy.eastwest-nat.id
  policy_type             = "FTDNatPolicy"
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
