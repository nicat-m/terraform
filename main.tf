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

locals {
  projects = {
    dc2-avis2-dev = {
      # Required parameters
      env                     = "dev"
      project_name            = "avis2-dev"

      #VM
      vm_vcpu          = "32"
      vm_memory        = "65536"
      vm_ipv4_netmask  = "24"
      vm_ipv4_gateway  = "10.122.61.254"
      vm_dns_servers   = ["10.122.53.53", "10.122.53.54"]
      dns_suffix_list  = ["vn.local"]
      vm_disk_label    = "disk0"
      vm_disk_size     = "120"
      vm_disk_thin     = "true"
      vm_domain        = "vn.local"

      vms = {
        node1 = {
          vm_name     = "dc2_AVIS2_dev_worker25"
          vm_hostname = "avis2-dev-worker25"
          vm_ip       = "10.122.61.86"
        },
        node2 = {
          vm_name     = "dc2_AVIS2_dev_worker26"
          vm_hostname = "avis2-dev-worker26"
          vm_ip       = "10.122.61.87"
        }
        }
      }
    }
  }





