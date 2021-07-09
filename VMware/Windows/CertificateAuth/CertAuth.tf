provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

variable "AppIP" {
    description = "IP Used By App"
    default = "31"
}

variable "AppName" {
    description = "Name Used By App"
    default = "AutoLabCA"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "Win2022-Template-Base"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  count = "1"
  name   = "${var.AppName}-${format("%02d",count.index + 1)}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  folder = "Domain Services"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    thin_provisioned = "true"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"





customize {
      windows_options {
        computer_name = "${var.AppName}-${format("%02d",count.index + 1)}"
        join_domain           = var.DomainName
        domain_admin_user     = var.Domain_Admin
        domain_admin_password = var.Domain_Password
      }

network_interface {
ipv4_address = "${var.VM_IPStart}.${(count.index + var.AppIP)}"
ipv4_netmask = 24

}

ipv4_gateway    = var.VM_Gateway
dns_server_list = ["${var.VM_IPStart}.21", "${var.VM_IPStart}.22"]

}


 }

 provisioner "local-exec" {
   command = "echo Waiting for WinRM/SSH to start..."
 }

 #Change to PWSH if using a Mac
 provisioner "local-exec" {
    command = "pwsh ./porttest.ps1 ${var.VM_IPStart}.${var.AppIP} 22"
  }



 provisioner "file" {
   source      = "BuildScripts/"
   destination = "C:/AutoLab"

   connection {
     type     = "ssh"
     user     = "autodeploy"
     password = "Aut0L@b!"
     host     = "${var.VM_IPStart}.${var.AppIP}"
     target_platform = "windows"
   }
}

provisioner "remote-exec" {
  inline = [
    "Powershell.exe -ExecutionPolicy Bypass -File C:/AutoLab/BuildServer.ps1"
  ]
  connection {
  type     = "ssh"
  user     = "autodeploy"
  password = "Aut0L@b!"
  host     = "${var.VM_IPStart}.${var.AppIP}"
    timeout  = "6m"
    target_platform = "windows"
    }
}

}
