#===============================================================================
# vSphere Data
#===============================================================================

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_drs_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vm_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

#===============================================================================
# Template files
#===============================================================================

# Kubespray all.yml template #
data "template_file" "kubespray_all" {
  template = file("${path.root}/files/templates/kubespray_all.tpl")

  vars = {
    loadbalancer_apiserver = "${var.vm_haproxy_vip}"
  }
}

# Kubespray k8s-cluster.yml template #
data "template_file" "kubespray_k8s_cluster" {
  template = file("${path.root}/files/templates/kubespray_k8s_cluster.tpl")

  vars = {
    kube_version        = "${var.k8s_version}"
    kube_network_plugin = "${var.k8s_network_plugin}"
    k8s_dns_mode        = "${var.k8s_dns_mode}"
    container_manager   = "${var.container_manager}"
  }
}

# HAProxy hostname and ip list template #
data "template_file" "haproxy_hosts" {
  count    = var.vm_haproxy_count
  template = file("${path.root}/files/templates/ansible_hosts.tpl")

  vars = {
    hostname = "${var.vm_name_prefix}-haproxy-${count.index}"
    host_ip  = "${local.vm_haproxy_range[count.index]}"
  }
}

# Kubespray master hostname and ip list template #
data "template_file" "kubespray_hosts_master" {
  count    = var.vm_master_count
  template = file("${path.root}/files/templates/ansible_hosts.tpl")

  vars = {
    hostname = "${var.vm_name_prefix}-master-${count.index}"
    host_ip  = "${local.vm_master_range[count.index]}"
  }
}

# Kubespray worker hostname and ip list template #
data "template_file" "kubespray_hosts_worker" {
  count    = var.vm_worker_count
  template = file("${path.root}/files/templates/ansible_hosts.tpl")

  vars = {
    hostname = "${var.vm_name_prefix}-worker-${count.index}"
    host_ip  = "${local.vm_worker_range[count.index]}"
  }
}

# HAProxy hostname list template #
data "template_file" "haproxy_hosts_list" {
  count    = var.vm_haproxy_count
  template = file("${path.root}/files/templates/ansible_hosts_list.tpl")

  vars = {
    hostname = "${var.vm_name_prefix}-haproxy-${count.index}"
  }
}

# Kubespray master hostname list template #
data "template_file" "kubespray_hosts_master_list" {
  count    = var.vm_master_count
  template = file("${path.root}/files/templates/ansible_hosts_list.tpl")

  vars = {
    hostname = "${var.vm_name_prefix}-master-${count.index}"
  }
}

# Kubespray worker hostname list template #
data "template_file" "kubespray_hosts_worker_list" {
  count    = var.vm_worker_count
  template = file("${path.root}/files/templates/ansible_hosts_list.tpl")

  vars = {
    hostname = "${var.vm_name_prefix}-worker-${count.index}"
  }
}

# HAProxy template #
data "template_file" "haproxy" {
  template = file("${path.root}/files/templates/haproxy.tpl")

  vars = {
    bind_ip = "${var.vm_haproxy_vip}"
  }
}

# HAProxy server backend template #
data "template_file" "haproxy_backend" {
  count    = var.vm_master_count
  template = file("${path.root}/files/templates/haproxy_backend.tpl")

  vars = {
    prefix_server     = "${var.vm_name_prefix}"
    backend_server_ip = "${local.vm_master_range[count.index]}"
    count             = "${count.index}"
  }
}

# Keepalived master template #
data "template_file" "keepalived_master" {
  template = file("${path.root}/files/templates/keepalived_master.tpl")

  vars = {
    virtual_ip          = "${var.vm_haproxy_vip}"
    virtual_router_id   = "${var.virtual_router_id}"
  }
}

# Keepalived slave template #
data "template_file" "keepalived_slave" {
  template = file("${path.root}/files/templates/keepalived_slave.tpl")

  vars = {
    virtual_ip          = "${var.vm_haproxy_vip}"
    virtual_router_id   = "${var.virtual_router_id}"
  }
}

data "vsphere_resource_pool" "resource_pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}