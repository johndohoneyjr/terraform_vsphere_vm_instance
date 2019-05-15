# Define authentification configuration

provider "vsphere" {
  # if you have a self-signed cert
  allow_unverified_ssl = true
}

#### RETRIEVE DATA INFORMATION ON VCENTER ####

data "vsphere_datacenter" "vdc" {
  name = "${var.vsphere_dc}"
}

# data "vsphere_resource_pool" "pool" {
#   # If you haven't resource pool, put "Resources" after cluster name
#   name          = "${var.vsphere_dc}/Resources"
#   datacenter_id = "${data.vsphere_datacenter.vdc.id}"
# }

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.vdc.id}"
}

data "vsphere_host" "host" {
  name          = "${var.vhost}"
  datacenter_id = "${data.vsphere_datacenter.vdc.id}"
}

# Retrieve datastore information on vsphere
data "vsphere_datastore" "datastore" {
  name          = "${var.vdatastore}"
  datacenter_id = "${data.vsphere_datacenter.vdc.id}"
}

# Retrieve network information on vsphere
data "vsphere_network" "vmnetwork" {
  name          = "${var.vmnetwork}"
  datacenter_id = "${data.vsphere_datacenter.vdc.id}"
}

# Retrieve template information on vsphere
data "vsphere_virtual_machine" "vmtemplate" {
  name          = "${var.vmtemplate}"
  datacenter_id = "${data.vsphere_datacenter.vdc.id}"
}

#### VM CREATION ####

# Set vm parameters
resource "vsphere_virtual_machine" "vm" {
  name             = "${var.guestname}"
  num_cpus         = 2
  memory           = 4096
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  host_system_id   = "${data.vsphere_host.host.id}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  guest_id         = "${data.vsphere_virtual_machine.vmtemplate.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.vmtemplate.scsi_type}"

  # Set network parameters
  network_interface {
    network_id = "${data.vsphere_network.vmnetwork.id}"
  }

  # Template should have a main disk associated
  disk {
    label = "${var.guestname}-sda.vmdk"
    size  = "16"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.vmtemplate.id}"

    customize {
      linux_options {
        host_name = "${var.guestname}"
        domain    = "test.internal"
      }

      network_interface {
        ipv4_address    = "10.100.0.111"
        ipv4_netmask    = 24
        dns_server_list = ["8.8.8.8", "8.8.4.4"]
      }

      ipv4_gateway = "10.100.0.1"
    }
  }

  # Execute script on remote vm after this creation
  provisioner "remote-exec" {
    script = "scripts/example-script.sh"

    connection {
      user     = "root"
      password = "secret"
      host     = "192.168.1.254"
    }
  }
}
