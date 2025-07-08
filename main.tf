module "vsphere" {
  for_each = local.projects
  source = "./modules/centralized-vms"
  env          = each.value.env
  project_name = each.value.project_name

  vsphere_datacenter      = var.vsphere_datacenter
  vsphere_compute_cluster = var.vsphere_compute_cluster
  vsphere_datastore       = var.vsphere_datastore
  vsphere_network         = var.vsphere_network
  vsphere_resource_pool   = var.vsphere_resource_pool
  vm_template_name        = var.vm_template_name

  vm_vcpu                 = each.value.vm_vcpu
  vm_memory               = each.value.vm_memory
  vm_ipv4_gateway         = each.value.vm_ipv4_gateway
  vm_ipv4_netmask         = each.value.vm_ipv4_netmask
  vm_dns_servers          = each.value.vm_dns_servers
  dns_suffix_list         = each.value.dns_suffix_list
  vm_disk_label           = each.value.vm_disk_label
  vm_disk_size            = each.value.vm_disk_size
  vm_disk_thin            = each.value.vm_disk_thin
  vm_domain               = each.value.vm_domain
  vms                     = each.value.vms
}





