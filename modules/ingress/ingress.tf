# Helm module for installing Helm and deploying Helm charts
resource "null_resource" "install-ingress" {

  provisioner "remote-exec" {
    inline = [
      "sudo helm install ingress -n ingress --create-namespace oci://ghcr.io/nginxinc/charts/nginx-ingress --version 1.2.0"
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

