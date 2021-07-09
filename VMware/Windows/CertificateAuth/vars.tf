variable "vsphere_server" {
    description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
    default = "vcsa.lab.virtualisedfruit.co.uk"
}

variable "vsphere_user" {
    description = "vsphere server for the environment - EXAMPLE: vsphereuser"
    default = "administrator@vf.vsphere"
}

data "vsphere_datacenter" "dc" {
  name = "VFDC"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "VMware"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "256NVME"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_host" "hs" {
  name = "192.168.70.110"
  datacenter_id = data.vsphere_datacenter.dc.id
}

variable "vsphere_password" {
    description = "vsphere server password for the environment"
    default = "B453Build&"
}


variable "VM_Gateway" {
    description = "vsphere server password for the environment"
    default = "192.168.70.254"
}

variable "VM_IPStart" {
    description = "vsphere server password for the environment"
    default = "192.168.70"
}

variable "DomainName" {
    description = "Domain Name Used"
    default = "AutoLabDomain.com"
}

variable "Domain_Admin" {
    description = "Domain Admin Used"
    default = "Administrator"
}

variable "Domain_Password" {
    description = "Domain Admin Used"
    default = "Aut0L@b!"
}
