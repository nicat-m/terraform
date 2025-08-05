output "vm_nodes" {
  value = {
    master_nodes  = local.vm_master_range
    worker_nodes  = local.vm_worker_range
    haproxy_nodes = local.vm_haproxy_range
  }
}

output "VM_Haproxy_VIP" {
  description = "Virtual Machine ip address"
  value       = var.vm_haproxy_vip
}