resource "null_resource" "install_metallb" {

  provisioner "remote-exec" {
    inline = [
      "sudo /usr/local/bin/kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.4/config/manifests/metallb-native.yaml",
      "sleep 30"
    ]
    connection {
        type =     "ssh"
        host =     values(var.vm_master_ips)[0]
        user =     var.vm_user
        password = var.vm_password
        timeout  = "10m"
  }
  }

  provisioner "file" {
     source      = "/Users/nijatmansimov/my-work/terraform/modules/metalLB/ip-pool.yaml"
     destination = "/home/nicat/ip-pool.yaml"
     connection {
        type =     "ssh"
        host =     values(var.vm_master_ips)[0]
        user =     var.vm_user
        password = var.vm_password
        timeout  = "10m"
  }
}
  provisioner "remote-exec" {
    inline = [
      "sudo /usr/local/bin/kubectl apply -f /home/nicat/ip-pool.yaml -n metallb-system"
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


