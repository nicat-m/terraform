
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



variable "vm_vcpu" {
  description = "The number of virtual processors to assign to this virtual machine."
  default     = "1"
}

variable "vm_memory" {
  description = "The size of the virtual machine's memory in MB"
  default     = "1024"
}

variable "vm_ipv4_netmask" {
  description = "The IPv4 subnet mask"
}

variable "vm_ipv4_gateway" {
  description = "The IPv4 default gateway"
}

variable "vm_dns_servers" {
  description = "The list of DNS servers to configure on the virtual machine"
}

variable "dns_suffix_list" {
  description = "The list of DNS suffix to configure on the virtual machine"
}

variable "vm_domain" {
  description = "Domain name of virtual machine"
}

variable "vms" {
  type        = map(any)
  description = "List of virtual machines to be deployed"
}

variable "vm_disk_label" {
  description = "Disk label of the created virtual machine"
}

variable "vm_disk_size" {
  description = "Disk size of the created virtual machine in GB"
}

variable "vm_disk_thin" {
  description = "Disk type of the created virtual machine , thin or thick"
}
variable "env" {
  description = "Environment of the virtual machine"
  type        = string
}
variable "project_name" {
  description = "Prefix for the name of the virtual machines and the hostname of the Kubernetes nodes"
}

