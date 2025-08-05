# Execute HAProxy Ansible playbook #
resource "null_resource" "haproxy_install" {
  count = var.action == "create" ? 1 : 0

  provisioner "local-exec" {
    command = "cd ${path.root}/files/ansible/haproxy && ansible-playbook -i ../kubespray/inventory/${var.project_name}/hosts.yaml -b -u ${var.vm_user} -e \"ansible_ssh_pass=$VM_PASSWORD ansible_become_pass=$VM_PRIVILEGE_PASSWORD KEEPALIVED_MASTER_CONFIG=$KEEPALIVED_MASTER_CONFIG KEEPALIVED_SLAVE_CONFIG=$KEEPALIVED_SLAVE_CONFIG HAPROXY_CONFIG=$HAPROXY_CONFIG\" ${lookup(local.extra_args, var.vm_distro)} -v haproxy.yml"

    environment = {
      VM_PASSWORD              = "${var.vm_password}"
      VM_PRIVILEGE_PASSWORD    = "${var.vm_privilege_password}"
      KEEPALIVED_MASTER_CONFIG = "../../config/${var.vm_name_prefix}/keepalived-master.cfg"
      KEEPALIVED_SLAVE_CONFIG  = "../../config/${var.vm_name_prefix}/keepalived-slave.cfg"
      HAPROXY_CONFIG           = "../../config/${var.vm_name_prefix}/haproxy.cfg"
    }
  }

  depends_on = [local_file.kubespray_hosts, local_file.haproxy, vsphere_virtual_machine.haproxy]
}

resource "null_resource" "install_requirements" {

  provisioner "local-exec" {
    command = "python3.10 -m venv ${path.root}/files/kubespray-env && bash -c 'source ${path.root}/files/kubespray-env/bin/activate && pip install -U -r ${path.root}/files/ansible/kubespray/requirements.txt'"
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [null_resource.haproxy_install, null_resource.kubespray_download]
}
# Execute create Kubespray Ansible playbook #
resource "null_resource" "kubespray_create" {
  count = var.action == "create" ? 1 : 0

  provisioner "local-exec" {
    command = "bash -c 'source ${path.root}/files/kubespray-env/bin/activate && cd ${path.root}/files/ansible/kubespray && ansible-playbook -i inventory/${var.project_name}/hosts.yaml -b -u ${var.vm_user} -e \"ansible_ssh_pass=$VM_PASSWORD ansible_become_pass=$VM_PRIVILEGE_PASSWORD kube_version=${var.k8s_version}\" ${lookup(local.extra_args, var.vm_distro)} -v cluster.yml'"

    environment = {
      VM_PASSWORD           = "${var.vm_password}"
      VM_PRIVILEGE_PASSWORD = "${var.vm_privilege_password}"
    }
  }

  depends_on = [local_file.kubespray_hosts, null_resource.kubespray_download, local_file.kubespray_all, local_file.kubespray_k8s_cluster, null_resource.haproxy_install, vsphere_virtual_machine.haproxy, vsphere_virtual_machine.worker, vsphere_virtual_machine.master, null_resource.install_requirements]
}

# Execute scale Kubespray Ansible playbook #
resource "null_resource" "kubespray_add" {
  count = var.action == "add_worker" ? 1 : 0

  provisioner "local-exec" {
    command = "bash -c 'source ${path.root}/files/kubespray-env/bin/activate && cd ${path.root}/files/ansible/kubespray && ansible-playbook -i inventory/${var.project_name}/hosts.yaml -b -u ${var.vm_user} -e \"ansible_ssh_pass=$VM_PASSWORD ansible_become_pass=$VM_PRIVILEGE_PASSWORD kube_version=${var.k8s_version}\" ${lookup(local.extra_args, var.vm_distro)} -v scale.yml'"

    environment = {
      VM_PASSWORD           = "${var.vm_password}"
      VM_PRIVILEGE_PASSWORD = "${var.vm_privilege_password}"
    }
  }

  depends_on = [local_file.kubespray_hosts, null_resource.kubespray_download, local_file.kubespray_all, local_file.kubespray_k8s_cluster, null_resource.haproxy_install, vsphere_virtual_machine.haproxy, vsphere_virtual_machine.worker, vsphere_virtual_machine.master]
}

# Execute upgrade Kubespray Ansible playbook #
resource "null_resource" "kubespray_upgrade" {
  count = var.action == "upgrade" ? 1 : 0

  triggers = {
    ts = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${path.root}/files/ansible
      if [ ! -d "kubespray" ]; then
        git clone --branch ${var.k8s_kubespray_version} ${var.k8s_kubespray_url}
      fi
    EOT
  }

  provisioner "local-exec" {
    command = "bash -c 'source ${path.root}/files/kubespray-env/bin/activate && cd ${path.root}/files/ansible/kubespray && ansible-playbook -i inventory/${var.project_name}/hosts.yaml -b -u ${var.vm_user} -e \"ansible_ssh_pass=$VM_PASSWORD ansible_become_pass=$VM_PRIVILEGE_PASSWORD kube_version=${var.k8s_version}\" ${lookup(local.extra_args, var.vm_distro)} -v upgrade-cluster.yml'"

    environment = {
      VM_PASSWORD           = "${var.vm_password}"
      VM_PRIVILEGE_PASSWORD = "${var.vm_privilege_password}"
    }
  }

  depends_on = [local_file.kubespray_hosts, null_resource.kubespray_download, local_file.kubespray_all, local_file.kubespray_k8s_cluster, null_resource.haproxy_install, vsphere_virtual_machine.haproxy, vsphere_virtual_machine.worker, vsphere_virtual_machine.master]
}

# Create the local admin.conf kubectl configuration file #
resource "null_resource" "kubectl_configuration" {
  provisioner "local-exec" {
    command = "bash -c 'source ${path.root}/files/kubespray-env/bin/activate && ansible -i ${local.vm_master_range[0]}, -b -u ${var.vm_user} -e \"ansible_ssh_pass=$VM_PASSWORD ansible_become_pass=$VM_PRIVILEGE_PASSWORD\" ${lookup(local.extra_args, var.vm_distro)} -m fetch -a \"src=/etc/kubernetes/admin.conf dest=${path.root}/files/config/${var.vm_name_prefix}.conf flat=yes\" all'"

    environment = {
      VM_PASSWORD           = "${var.vm_password}"
      VM_PRIVILEGE_PASSWORD = "${var.vm_privilege_password}"
    }
  }
  provisioner "local-exec" {
    command = "sed 's/lb-apiserver.kubernetes.local/${var.vm_haproxy_vip}/g' ${path.root}/files/config/${var.vm_name_prefix}.conf | tee ${path.root}/files/config/${var.vm_name_prefix}.conf.new && mv ${path.root}/files/config/${var.vm_name_prefix}.conf.new ${path.root}/files/config/${var.vm_name_prefix}.conf && chmod 700 ${path.root}/files/config/${var.vm_name_prefix}.conf"
  }

  provisioner "local-exec" {
    command = "chmod 600 ${path.root}/files/config/${var.vm_name_prefix}.conf"
  }

  depends_on = [null_resource.kubespray_create]
}

resource "null_resource" "set_ntp_for_all_machine" {

  provisioner "local-exec" {
    command = "cd ${path.root}/files/ansible/tools && ansible-playbook -i ../kubespray/inventory/${var.project_name}/hosts.yaml -b -u ${var.vm_user} -e \"ansible_ssh_pass=$VM_PASSWORD ansible_become_pass=$VM_PRIVILEGE_PASSWORD VM_GATEWAY=$VM_GATEWAY\" ${lookup(local.extra_args, var.vm_distro)} -v set-ntp.yml"

    environment = {
      VM_PASSWORD              = "${var.vm_password}"
      VM_PRIVILEGE_PASSWORD    = "${var.vm_privilege_password}"
      VM_GATEWAY               = "${var.vm_gateway}"
    }
  }

  depends_on = [ vsphere_virtual_machine.master,vsphere_virtual_machine.haproxy,vsphere_virtual_machine.worker ]

}
