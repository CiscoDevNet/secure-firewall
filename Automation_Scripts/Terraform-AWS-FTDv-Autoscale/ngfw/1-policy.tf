##################
# Access Policy
##################

# Network Objects
resource "fmc_network_objects" "app_subnet" {
  name        = "app_subnet"
  value       = var.app_subnet
  description = "App Network"
}

# Host Objects
resource "fmc_host_objects" "app_server" {
  name        = "app_server"
  value       = var.app_server
  description = "App Server"
}

resource "fmc_host_objects" "metadata_server" {
  name        = "aws-metadata-server"
  value       = "169.254.169.254"
  description = "GWLB Health Check IP"
}


# Create default Access Control Policy
resource "fmc_access_policies" "access_policy" {
  name           = "FTDv-Access-Policy"
  default_action = "block"
}

# IPS Policy
resource "fmc_ips_policies" "ips_policy" {
  name            = "ftdv_ips_policy"
  inspection_mode = "DETECTION"
  basepolicy_id   = data.fmc_ips_policies.ips_base_policy.id
}

# Access Control Policy Rules
#########################################################

resource "fmc_access_rules" "access_rule_1" {
  #depends_on = [fmc_devices.ftd]
  acp                = fmc_access_policies.access_policy.id
  section            = "mandatory"
  name               = "Permit Outbound"
  action             = "allow"
  enabled            = true
  send_events_to_fmc = true
  log_files          = false
  log_begin          = true
  log_end            = true
  source_networks {
    source_network {
      id   = fmc_network_objects.app_subnet.id
      type = "Network"
    }
  }
  destination_ports {
    destination_port {
      id   = data.fmc_port_objects.http.id
      type = "TCPPortObject"
    }
    destination_port {
      id   = data.fmc_port_objects.https.id
      type = "TCPPortObject"
    }
  }
  ips_policy   = fmc_ips_policies.ips_policy.id
  new_comments = ["outbound web traffic"]
}

resource "fmc_access_rules" "access_rule_2" {
  #depends_on = [fmc_devices.ftd]
  acp                = fmc_access_policies.access_policy.id
  section            = "mandatory"
  name               = "Access to App Server"
  action             = "allow"
  enabled            = true
  send_events_to_fmc = true
  log_files          = false
  log_begin          = true
  log_end            = true
  destination_networks {
    destination_network {
      id   = fmc_host_objects.app_server.id
      type = "Host"
    }
    destination_network {
      id   = fmc_host_objects.metadata_server.id
      type = "Host"
    }
  }
  destination_ports {
    destination_port {
      id   = data.fmc_port_objects.ssh.id
      type = "TCPPortObject"
    }
  }
  ips_policy   = fmc_ips_policies.ips_policy.id
  new_comments = ["SSH to App Server"]
}