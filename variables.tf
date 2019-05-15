# Variables for deploying an vSphere virtual machine instance

variable "vsphere_dc" {
  description = "The vSphere datacenter name"
  default     = "PacketDatacenter"
}

variable "vhost" {
  description = "Name or IP address of ESXi host"
  default     = "10.100.0.2"
}

variable "vdatastore" {
  description = "Name of datastore to use for deployments"
  default     = "datastore1"
}

variable "vmnetwork" {
  description = "Name of network to use for virtual machines"
  default     = "VM Network"
}

variable "vmtemplate" {
  description = "Name of virtual machine template to use to deploy instance"
  default     = "Ubuntu"
}

variable "guestname" {
  description = "Name of virtual machine"
  default     = "beau-ubuntu-sandbox"
}
