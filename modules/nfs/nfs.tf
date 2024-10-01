# Helm module for installing Helm and deploying Helm charts
resource "null_resource" "install-ingress" {

  provisioner "remote-exec" {
    inline = [
      "sudo helm repo add nfs https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner",
      "sudo helm install nfs-client1 -n nfs --set nfs.server=10.120.0.0 --set nfs.path=/nfs ."
    ]
    connection {
        type =     "ssh"
        host =     values(var.vm_master_ips)[0]
        user =     var.vm_user
        password = var.vm_password
        timeout  = "10m"
  }
  }
}

