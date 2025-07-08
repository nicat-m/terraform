output "DC_ID" {
  description = "id of vSphere Datacenter"
  value       = data.vsphere_datacenter.dc.id
}
 
output "VM_Master" {
  description = "Virtual Machine ip address"
  value       = var.vm_master_ips
}
 
output "VM_Worker" {
  description = "Virtual Machine ip address"
  value       = var.vm_worker_ips
}
 
output "VM_Haproxy" {
  description = "Virtual Machine ip address"
  value       = var.vm_haproxy_ips
}
 
output "VM_Haproxy_VIP" {
  description = "Virtual Machine ip address"
  value       = var.vm_haproxy_vip
}
