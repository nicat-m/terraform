# Helm module for installing Helm and deploying Helm charts
resource "null_resource" "install-ingress" {

  provisioner "remote-exec" {
    inline = [
      "sudo su - ",
      "curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.21.0 TARGET_ARCH=x86_64 sh -",
      "cd istio-1.21.0",
      "export PATH=$PWD/bin:$PATH",
      "istioctl install -y"

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

