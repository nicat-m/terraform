# Terraform Project


This repository contains the Terraform configuration for managing our infrastructure. The structure of the repository is organized to separate concerns and improve maintainability.

## Repository Structure
    .
    ├── modules
    │   ├── helm
    │   ├── ingress
    │   ├── istio
    │   ├── nfs
    │   └── metalLB
    ├── README.md
    ├── terraform-variable.sh
    └── services
        ├── create-empty-vms
        └── create-kubernetes-vms

- **modules/**: This directory contains reusable kubernetes third party tools and terraform modules. For example (helm,metallb,istio)
- if you want to add module to main terraform file you have to do like this:
    ```sh
    Example:
    module "helm" {
            source         = "../../modules/helm"
            vm_password    = var.vm_password
            vm_user        = var.vm_user
            vm_master_ips  = var.vm_master_ips
            depends_on     = [null_resource.kubectl_configuration]
            }

- **services/**: This directory includes service-specific configurations. Each service has its own set of Terraform files to manage its infrastructure.
- if you want to create empty multiple vms you have to use **create-empty-vms** folder:
    ```sh
    create-empty-vms/terraform.tfvars you can change according to your wishes
    Example:
    .
    .
    .
    vms = {
        node1 = {
            name    = "node-name"
            vm_ip   = "node-ip"
            },
        node2 = {
            name    = "node-name"
            vm_ip   = "node-ip"
        }
    .
    .
    .

- if you want to create kubernetes cluster vms you have to use **create-kubernetes-vms** folder:
    ```sh

    create-kubernetes-vms/terraform.tfvars you can change according to your wishes:
    Example:

    vm_master_ips 
    vm_worker_ips
    vm_haproxy_ips
       
- **terraform-variable.sh**: A script for managing environment variables needed by Terraform. This script helps in setting up the necessary variables before running Terraform commands. 

## Getting Started

To get started with this project, you need to have Terraform installed on your local machine. Follow the instructions below to set up the project and start managing your infrastructure.

### Requirements

- [Terraform] You can download from this link: (https://www.terraform.io/downloads.html) version 1.0.0 or later
- Git                   (this is for only create-kubernetes-vms)
- Ansible v2.6 or v2.7  (this is for only create-kubernetes-vms)
- Jinja >= 2.9.6        (this is for only create-kubernetes-vms)
- Python v3             (this is for only create-kubernetes-vms)
- Postgresql for store terraform.tfstate file 
- Internet connection on the client machine to download Kubespray.
- Internet connection on the Kubernetes nodes to download the Kubernetes binaries.
- vSphere environment with a vCenter. An enterprise plus license is needed if you would like to configure anti-affinity between the Kubernetes master nodes.
- A Linux vSphere template. If linked clone is used, the template needs to have one and only one snapshot(due to a current bug in the provider, the template also need to be just a power off VM and not an actual vSphere template).

### Create a VMS
   ```plaintext
*** Create Kubernetes Cluster ***

$ git clone https://gitlab.e-taxes.gov.az/devops-team/terraform.git
$ cd terraform

Please edit terraform-variable.sh file set your credentials
$ source ./terraform-variable.sh

$ cd create-kubernetes-vms
Edit your backend configuration for store tfstate file

$ vim backend.tf (set your postgresql config)

$ vim terraform.tfvars (set master,worker and haproxy ip,node-name,cpu,ram,hdd,OS)

Then run following command:

$ terraform init       (this command initialize package need for terraform )

$ terraform validate   (this command check syntax)

$ terraform plan --out create-k8s.plan (this command show your infrastructure how to appear latest)

if everything is okay then run this command:

$ terraform apply




### Add a worker node

Add one or several worker nodes to the k8s_worker_ips list:

$ vim terraform.tfvars

Execute the terraform script to add the worker nodes:

$ terraform apply -var 'action=add\_worker'

### Delete a worker node

Remove one or several worker nodes to the k8s_worker_ips list:

$ vim terraform.tfvars

Execute the terraform script to remove the worker nodes:

$ terraform apply -var 'action=remove\_worker'

### Upgrade Kubernetes

Modify the k8s_version and the k8s_kubespray_version variables:

$ vim terraform.tfvars

| Kubernetes version | Kubespray version |
|:------------------:|:-----------------:|
|      v1.15.3       |      v2.11.0      |
|      v1.14.3       |      v2.10.3      |
|      v1.14.1       |      v2.10.0      |
|      v1.13.5       |      v2.9.0       |
|      v1.12.5       |      v2.8.2       |
|      v1.12.4       |      v2.8.1       |
|      v1.12.3       |      v2.8.0       |

Execute the terraform script to upgrade Kubernetes:

$ terraform apply -var 'action=upgrade'

Destroy infrastructure please pay attention !!!

$ terraform destroy



========================================================================================

*** Create a Empty VMS ***

$ git clone https://gitlab.e-taxes.gov.az/devops-team/terraform.git
$ cd terraform

Please edit terraform-variable.sh file set your credentials
$ source ./terraform-variable.sh

$ cd create-empty-vms

Edit your backend configuration for store tfstate file
   
$ vim backend.tf (set your postgresql config)  

$ vim terraform.tfvars (set vms ip,node-name,cpu,ram,hdd,OS)

Then run following command:

$ terraform init       (this command initialize package need for terraform )

$ terraform validate   (this command check syntax)

$ terraform plan --out create-vms.plan (this command show your infrastructure how to appear latest)

if everything is okay then run this command:

$ terraform apply

Destroy infrastructure please pay attention !!!

$ terraform destroy


