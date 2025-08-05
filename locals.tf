locals {
  projects = {
    develop = {
      project_name          = "develop"
      vm_name_prefix        = "dc1-develop"
      vm_datastore          = "DC2_E590H_02_Admins_Test"
      vsphere_resource_pool = "DC2_DevOPS_Test"
      vm_network            = "VLAN65"
      vm_netmask            = "24"
      vm_gateway            = "10.122.65.254"
      vm_dns                = ["10.122.53.53", "10.122.53.54"]
      vm_dns_suffix         = ["vn.local"]
      vm_cidr               = "10.122.65.0/24"
      vm_domain             = "nicat-test"
      vm_distro             = "centos"

      vm_master_cpu         = "4"
      vm_master_ram         = "4096"
      vm_master_disk_size   = "140"
      vm_master_count       = "3"
      vm_master_start_ip    = "1"
      vm_master_end_ip      = "4"

      vm_worker_cpu         = "4"
      vm_worker_ram         = "4096"
      vm_worker_disk_size   = "140"
      vm_worker_count       = "1"
      vm_worker_start_ip    = "4"
      vm_worker_end_ip      = "5"

      vm_haproxy_cpu        = "2"
      vm_haproxy_ram        = "4096"
      vm_haproxy_vip        = "10.122.65.100"
      vm_haproxy_count      = "2"
      vm_haproxy_start_ip   = "98"
      vm_haproxy_end_ip     = "100"

      metal_LB_IP           = ["10.122.65.110-10.122.65.111"]
      virtual_router_id     = 51

      k8s_kubespray_version = "release-2.28"
      k8s_version           = "1.32.0"
    }
  }
}
