#====================#
# vCenter connection #
#====================#


variable "vm_user" {
  description = "SSH user for the vSphere virtual machines"
}

variable "vm_password" {
  description = "SSH password for the vSphere virtual machines"
}

variable "vm_master_ips" {
  type        = map
  description = "IPs used for the Kubernetes master nodes"
}

