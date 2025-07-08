#Provider -  VMware vSphere Provider
variable "vsphere_user" {
  description = "vSphere username to use to connect to the environment"
}

variable "vsphere_password" {
  description = "vSphere password to use to connect to the environment"
}

variable "vsphere_vcenter" {
  description = "vCenter server FQDN or IP"
}

# Infrastructure - vCenter / vSPhere environment

variable "vsphere_datacenter" {
  description = "vSphere datacenter in which the virtual machine will be deployed"
}

#variable "vsphere_host" {
#  description = "vSphere ESXi host FQDN or IP"
#}

variable "vsphere_compute_cluster" {
  description = "vSPhere cluster in which the virtual machine will be deployed"
}


variable "vsphere_resource_pool" {
  description = "vsphere_resource_pool pool id "
}

variable "vsphere_datastore" {
  description = "Datastore in which the virtual machine will be deployed"
}

variable "vsphere_network" {
  description = "Portgroup to which the virtual machine will be connected"
}
#VM

variable "vm_template_name" {
  description = "VM template with vmware-tools and perl installed"
}
