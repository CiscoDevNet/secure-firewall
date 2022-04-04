terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}

provider "vsphere" {
  user                 = var.userid
  password             = var.password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}



data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.mgmt_network
  datacenter_id = data.vsphere_datacenter.dc.id

}

data "vsphere_network" "inside" {
  name          = var.inside_network
  datacenter_id = data.vsphere_datacenter.dc.id

}

data "vsphere_network" "outside" {
  name          = var.outside_network
  datacenter_id = data.vsphere_datacenter.dc.id

}

resource "null_resource" "iso" {
  provisioner "local-exec" {
    command = "cp ${var.day0_config} day0-config && genisoimage -r -o day0.iso day0-config && rm day0-config"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm day0.iso"
    on_failure = continue
  }
}

resource "vsphere_file" "iso" {
  datacenter       = var.datacenter
  datastore        = "esxi3-datastore"
  source_file      = "./day0.iso"
  destination_file = "${var.hostname}/day0.iso"

  depends_on = [
    null_resource.iso
  ]
}

resource "vsphere_virtual_machine" "vmFromLocalOvf" {
  name                       = var.hostname
  resource_pool_id           = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id               = data.vsphere_datastore.datastore.id
  host_system_id             = data.vsphere_host.host.id
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  datacenter_id              = data.vsphere_datacenter.dc.id

  num_cpus = 4
  memory   = 8192

  ovf_deploy {
    local_ovf_path       = var.ovf_path
    disk_provisioning    = "thin"
    ip_protocol          = "IPV4"
    ip_allocation_policy = "STATIC_MANUAL"
  }

  scsi_type = "lsilogic"

  #cdrom {
  #  client_device = true
  #}

  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "${var.hostname}/day0.iso"
  }

  vapp {
    properties = {
      "HARole"   = "Standalone"
      "Hostname" = var.hostname
    }
  }
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  network_interface {
    network_id = data.vsphere_network.inside.id
  }

  network_interface {
    network_id = data.vsphere_network.outside.id
  }

  depends_on = [
    vsphere_file.iso
  ]
}
