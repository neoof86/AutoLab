provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

variable "AppIP" {
    description = "IP Used By App"
    default = "XX"
}

variable "AppName" {
    description = "Name Used By App"
    default = "AutoLab_OVAXXSS"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}



resource "vsphere_virtual_machine" "vmFromLocalOvf" {
  name                       = "${var.AppName}"
  resource_pool_id           = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  host_system_id             = data.vsphere_host.hs.id
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  num_cpus = 2
  memory   = 6144
  datacenter_id              = data.vsphere_datacenter.dc.id
  network_interface {
  network_id   = "${data.vsphere_network.network.id}"
}
  ovf_deploy {
    local_ovf_path       = "./OVA/XXX.ova"
    disk_provisioning    = "thin"

  }

  vapp {
    properties = {
    "ip0" = "${var.VM_IPStart}.${var.AppIP}",
    "DNS" = "${var.VM_IPStart}.21, ${var.VM_IPStart}.22",
    "gateway" = "${var.VM_Gateway}"
    "netmask0" = "255.255.255.0"
    "hostname" = "${var.AppName}"
    }
  }
}
