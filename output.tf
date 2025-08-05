output "vm_node_list" {
  value = {
    for k, mod in module.k8s-cluster :
    k => mod.vm_nodes
  }
}

output "haproxy_VIP" {
  value = {
    for k, mod in module.k8s-cluster :
    k => mod.VM_Haproxy_VIP
  }
}