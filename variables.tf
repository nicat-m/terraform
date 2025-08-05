variable "vsphere_user" {
  description = "vSphere user name"
  sensitive = true
}

variable "vsphere_password" {
  description = "vSphere password"
  sensitive = true
}

variable "vsphere_vcenter" {
  description = "vCenter server FQDN or IP"
}

variable "vsphere_unverified_ssl" {
  description = "Is the vCenter using a self signed certificate (true/false)"
  default     = true
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
}

variable "vsphere_drs_cluster" {
  description = "vSphere cluster"
  default     = ""
}

variable "vm_template" {
  description = "Template used to create the vSphere virtual machines (linked clone)"
}
variable "vm_user" {
  
}
variable "vm_password" {
  
}
variable "vm_privilege_password" {
  
}