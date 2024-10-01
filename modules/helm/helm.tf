# Helm module for installing Helm and deploying Helm charts
resource "null_resource" "install_helm" {

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y curl",
      "curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3",
      "chmod 700 get_helm.sh", 
      "./get_helm.sh"
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

