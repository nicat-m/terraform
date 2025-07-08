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