#Infrastructure
vsphere_datacenter      = "DC2-DVX_Datacenter"
#vsphere_host           = "10.122.22.7"
vsphere_compute_cluster = "DC2-DVX_Cluster"
vsphere_datastore       = "DC2_Admins_Test"
vsphere_network         = "VLAN65"
vsphere_resource_pool   = "DC2_DVX_DevOPS_Test"


#VM
vm_template_name        = "dc2_Redhat8_Temp_for_users"
vm_guest_id             = "rhel8_64Guest"
vm_vcpu                 = "2"
vm_memory               = "8192"
vm_ipv4_netmask         = "24"
vm_ipv4_gateway         = "10.122.65.254"
vm_dns_servers          = ["10.122.53.53", "10.122.53.54"]
dns_suffix_list         = ["vn.local"]
vm_disk_label           = "disk0"
vm_disk_size            = "120"
vm_disk_thin            = "true"
vm_domain               = "example.com"
vm_firmware             = "efi"

vms = {
  terraform-node1 = {
    name                = "node1"
    vm_ip               = "10.122.65.175"
  }
}
