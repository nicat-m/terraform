#===============================================================================
# Local Files
#===============================================================================

# Create Kubespray all.yml configuration file from Terraform template #
resource "local_file" "kubespray_all" {
  content  = data.template_file.kubespray_all.rendered
  filename = "${path.root}/files/ansible/kubespray/inventory/${var.project_name}/group_vars/all/all.yml"
  depends_on = [ null_resource.kubespray_download ]
}

# Create Kubespray k8s-cluster.yml configuration file from Terraform template #
resource "local_file" "kubespray_k8s_cluster" {
  content  = data.template_file.kubespray_k8s_cluster.rendered
  filename = "${path.root}/files/ansible/kubespray/inventory/${var.project_name}/group_vars/k8s_cluster/k8s-cluster.yml"
  depends_on = [ null_resource.kubespray_download ]
}

# Create Kubespray hosts.yaml configuration file from Terraform templates #
resource "local_file" "kubespray_hosts" {
  content  = "${join("", data.template_file.haproxy_hosts.*.rendered)}${join("", data.template_file.kubespray_hosts_master.*.rendered)}${join("", data.template_file.kubespray_hosts_worker.*.rendered)}\n[haproxy]\n${join("", data.template_file.haproxy_hosts_list.*.rendered)}\n[kube-master]\n${join("", data.template_file.kubespray_hosts_master_list.*.rendered)}\n[etcd]\n${join("", data.template_file.kubespray_hosts_master_list.*.rendered)}\n[kube-node]\n${join("", data.template_file.kubespray_hosts_worker_list.*.rendered)}\n[k8s_cluster:children]\nkube-master\nkube-node"
  filename = "${path.root}/files/ansible/kubespray/inventory/${var.project_name}/hosts.yaml"
  depends_on = [ null_resource.kubespray_download ]
}

# Create HAProxy configuration from Terraform templates #
resource "local_file" "haproxy" {
  content  = "${data.template_file.haproxy.rendered}${join("", data.template_file.haproxy_backend.*.rendered)}"
  filename = "${path.root}/files/config/${var.vm_name_prefix}/haproxy.cfg"
}

# Create Keepalived master configuration from Terraform templates #
resource "local_file" "keepalived_master" {
  content  = data.template_file.keepalived_master.rendered
  filename = "${path.root}/files/config/${var.vm_name_prefix}/keepalived-master.cfg"
}

# Create Keepalived slave configuration from Terraform templates #
resource "local_file" "keepalived_slave" {
  content  = data.template_file.keepalived_slave.rendered
  filename = "${path.root}/files/config/${var.vm_name_prefix}/keepalived-slave.cfg"
}

#===============================================================================
# Locals
#===============================================================================

# Extra args for ansible playbooks #
locals {
  extra_args = {
    ubuntu                  = "-T 300"
    debian                  = "-T 300 -e 'ansible_become_method=su'"
    centos                  = "-T 300"
    rhel                    = "-T 300"
  }
}

locals {
  guest_id = data.vsphere_virtual_machine.template.guest_id
}

# Modify the permission on the config directory
resource "null_resource" "config_permission" {
  provisioner "local-exec" {
    command = "chmod -R 700 ${path.root}/files/config"
  }

  depends_on = [local_file.haproxy, local_file.kubespray_hosts, local_file.kubespray_k8s_cluster, local_file.kubespray_all]
}

locals {
  vm_master_range = [for i in range(var.vm_master_start_ip, var.vm_master_end_ip) : cidrhost(var.vm_cidr, i)]
}

locals {
  vm_worker_range = [for i in range(var.vm_worker_start_ip, var.vm_worker_end_ip) : cidrhost(var.vm_cidr, i)]
}

locals {
  vm_haproxy_range = [for i in range(var.vm_haproxy_start_ip, var.vm_haproxy_end_ip) : cidrhost(var.vm_cidr, i)]
}