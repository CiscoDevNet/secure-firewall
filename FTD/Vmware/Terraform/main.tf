provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network1" {
  name          = var.network_name1
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network2" {
  name          = var.network_name2
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network3" {
  name          = var.network_name3
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network4" {
  name          = var.network_name4
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "FTD" {
  name                       = "ftd01"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  host_system_id             = data.vsphere_host.host.id
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  datacenter_id              = data.vsphere_datacenter.dc.id
  num_cpus = var.cpu
  memory = var.memory
  scsi_type = "lsilogic"
  ovf_deploy {
    local_ovf_path       = "Cisco_Firepower_Threat_Defense_Virtual-VI-7.0.0-94.ovf"
    disk_provisioning    = "thin"
    ip_protocol          = "IPV4"
    ip_allocation_policy = "STATIC_MANUAL"
  }

  disk {
    label = "disk0"
    size  = "40"
    attach = true
  }

  network_interface {
    network_id = data.vsphere_network.network1.id

  }
  network_interface {
    network_id = data.vsphere_network.network2.id

  }
  network_interface {
    network_id = data.vsphere_network.network3.id

  }
  network_interface {
    network_id = data.vsphere_network.network4.id

  }

   cdrom {
     client_device = true
   } 

  vapp {
    properties = {
      "pw"    = var.password,
      "ipv4.how" = var.mgmt_ip4_config,
      "ipv4.addr" = var.mgmt_ip4,
      "ipv4.gw" = var.mgmt_ip4_gateway,
      "ipv4.mask" = var.mgmt_ip4_mask,
      "ipv6.how" = var.mgmt_ip6_config,
      "ipv6.addr" = var.mgmt_ip6,
      "ipv6.gw" = var.mgmt_ip6_gateway,
      "ipv6.mask" = var.mgmt_ip6_mask,     
      "fqdn" = var.hostname,
      "firewallmode" = var.firewall_mode,
      "dns1" = var.dns1,
      "dns2" = var.dns2,
      "dns3" = var.dns3,
      "manageLocally" = var.local_manager,
      "mgr" = var.fmc_ip,
      "regkey" = var.fmc_regkey,
      "regNAT" = var.fmc_nat_id,
      "searchdomains" = var.searchdomains
    }
  }
}