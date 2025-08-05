# 🌐 Centralized Kubernetes VM Provisioning with Terraform


## 📁 Project Structure

### This repository is used to provision and manage Kubernetes clusters using Terraform.

```plaintext
.
├── modules
│   └── centralized-kubernetes-cluster     # Reusable module to create K8s
├── backend.tf                             # Remote backend configuration for state management
├── locals.tf                              # Defines local variables (VM groups)
├── main.tf                                # Main Terraform logic and module calls
├── output.tf                              # Outputs such as VM names and IPs
├── terraform.tf                           # Provider and general settings
├── variables.tf                           # Input variables definition
├── terraform.tfvars.example               # Terraform variables example (tfvars)
└── README.md                              # Project documentation
```

## Creating a New Kubernetes Cluster

```hcl
locals {
  projects = {
    develop = {
      project_name          = "develop"
      vm_name_prefix        = "dc1-develop"
      vm_datastore          = "DC2_E590H_02_Admins_Test"
      vsphere_resource_pool = "DC2_DevOPS_Test"
      vm_network            = "VLAN65"
      vm_netmask            = "24"
      vm_gateway            = "10.122.65.254"
      vm_dns                = ["10.122.53.53", "10.122.53.54"]
      vm_dns_suffix         = ["example.local"]
      vm_cidr               = "10.122.65.0/24"
      vm_domain             = "nicat-test"
      vm_distro             = "centos"

      vm_master_cpu       = "4"
      vm_master_ram       = "4096"
      vm_master_disk_size = "140"
      vm_master_count     = "3"
      vm_master_start_ip  = "1"
      vm_master_end_ip    = "4"

      vm_worker_cpu       = "4"
      vm_worker_ram       = "4096"
      vm_worker_disk_size = "140"
      vm_worker_count     = "1"
      vm_worker_start_ip  = "4"
      vm_worker_end_ip    = "5"

      vm_haproxy_cpu      = "2"
      vm_haproxy_ram      = "4096"
      vm_haproxy_vip      = "10.122.65.100"
      vm_haproxy_count    = "2"
      vm_haproxy_start_ip = "98"
      vm_haproxy_end_ip   = "100"

      metal_LB_IP          = ["10.122.65.110-10.122.65.111"]
      virtual_router_id    = 51
    },
    prod = {
             ...
             ...
    }
  }
}

```

🚀 Getting Started
```shell

terraform init
terraform validate
terraform plan
terraform apply
```

### Add a worker node

Add one or several worker nodes to the k8s_worker_ips list:

Execute the terraform script to add the worker nodes:

```shell

vim terraform.tfvars

terraform apply -var 'action=add_worker'
```

### Upgrade Kubernetes

Modify the k8s_version and the k8s_kubespray_version variables:
```shell

 vim locals.tf  # in root directory 
```

| Kubernetes version | Kubespray version |
|:------------------:|:-----------------:|
|       1.32.0       |   release-2.28    |
|       1.27.0       |   release-2.25    |
|       1.22.0       |   release-2.20    |

Execute the terraform script to upgrade Kubernetes:
```shell

 terraform apply -var 'action=upgrade'
```


Destroy infrastructure please pay attention !!!

```shell

terraform destroy
```
