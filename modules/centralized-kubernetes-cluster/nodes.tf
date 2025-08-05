# Create the Kubernetes master VMs #

resource "vsphere_virtual_machine" "master" {
  count            = var.vm_master_count
  name             = "${var.vm_name_prefix}-master-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus         = var.vm_master_cpu
  memory           = var.vm_master_ram
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  firmware         = data.vsphere_virtual_machine.template.guest_id == local.guest_id ? "efi" : "bios"
  enable_disk_uuid = "true"
  disk {
    size             = var.vm_master_disk_size
    label            = "${var.vm_name_prefix}-master-${count.index}.vmdk"
    thin_provisioned = var.vm_master_disk_thin
  }

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.vm_linked_clone

    customize {
      timeout = "20"

      linux_options {
        host_name = "${var.vm_name_prefix}-master-${count.index}"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = local.vm_master_range[count.index]
        ipv4_netmask = var.vm_netmask
      }

      ipv4_gateway    = var.vm_gateway
      dns_server_list = var.vm_dns
      dns_suffix_list = var.vm_dns_suffix
    }
  }

  depends_on = [vsphere_virtual_machine.haproxy]
}

# Create anti affinity rule for the Kubernetes master VMs #
resource "vsphere_compute_cluster_vm_anti_affinity_rule" "master_anti_affinity_rule" {
  count               = var.vsphere_enable_anti_affinity == "true" ? 1 : 0
  name                = "${var.vm_name_prefix}-master-anti-affinity-rule"
  compute_cluster_id  = data.vsphere_compute_cluster.cluster.id
  virtual_machine_ids = ["${vsphere_virtual_machine.master.*.id}"]

  depends_on = [vsphere_virtual_machine.master]
}

# Create the Kubernetes worker VMs #
resource "vsphere_virtual_machine" "worker" {
  count            = var.vm_worker_count
  name             = "${var.vm_name_prefix}-worker-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus         = var.vm_worker_cpu
  memory           = var.vm_worker_ram
  firmware         = data.vsphere_virtual_machine.template.guest_id == local.guest_id ? "efi" : "bios"
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  enable_disk_uuid = "true"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    size             = var.vm_worker_disk_size
    label            = "${var.vm_name_prefix}-worker-${count.index}.vmdk"
    thin_provisioned = var.vm_worker_disk_thin
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.vm_linked_clone

    customize {
      timeout = "20"

      linux_options {
        host_name = "${var.vm_name_prefix}-worker-${count.index}"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = local.vm_worker_range[count.index]
        ipv4_netmask = var.vm_netmask
      }

      ipv4_gateway    = var.vm_gateway
      dns_server_list = var.vm_dns
      dns_suffix_list = var.vm_dns_suffix
    }
  }

  depends_on = [vsphere_virtual_machine.master, local_file.kubespray_hosts, local_file.kubespray_k8s_cluster, local_file.kubespray_all]
}

# Create the HAProxy load balancer VM #
resource "vsphere_virtual_machine" "haproxy" {
  count            = var.vm_haproxy_count
  name             = "${var.vm_name_prefix}-haproxy-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_haproxy_cpu
  memory   = var.vm_haproxy_ram
  firmware = data.vsphere_virtual_machine.template.guest_id == local.guest_id ? "efi" : "bios"
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "${var.vm_name_prefix}-haproxy-${count.index}.vmdk"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.vm_linked_clone

    customize {
      timeout = "20"

      linux_options {
        host_name = "${var.vm_name_prefix}-haproxy-${count.index}"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = local.vm_haproxy_range[count.index]
        ipv4_netmask = var.vm_netmask
      }

      ipv4_gateway    = var.vm_gateway
      dns_server_list = var.vm_dns
      dns_suffix_list = var.vm_dns_suffix
    }
  }
}