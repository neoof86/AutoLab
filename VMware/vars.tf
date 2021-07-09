variable "vsphere_server" {
    description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
    default = "vcsa.tld.com"
}

variable "vsphere_user" {
    description = "vsphere server for the environment - EXAMPLE: vsphereuser"
    default = "administrator@sso.domain"
}

data "vsphere_datacenter" "dc" {
  name = "YourDC"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "YourCluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "YourDataStore"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_host" "hs" {
  name = "AHostToDeployTo"
  datacenter_id = data.vsphere_datacenter.dc.id
}

variable "vsphere_password" {
    description = "vsphere server password for the environment"
    default = "P@ssW0rd!"
}


variable "VM_Gateway" {
    description = "vsphere server password for the environment"
    default = "XXX.XXX.XXX.XXX"
}

variable "VM_IPStart" {
    description = "vsphere server password for the environment"
    default = "XXX.YYY.ZZZ"
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
