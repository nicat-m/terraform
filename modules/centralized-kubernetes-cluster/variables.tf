variable "vsphere_datacenter" {
  description = "vSphere datacenter"
}

variable "vsphere_drs_cluster" {
  description = "vSphere cluster"
  default     = ""
}

variable "vsphere_resource_pool" {
  description = "vSphere resource pool"
}

variable "vsphere_enable_anti_affinity" {
  description = "Enable anti affinity between master VMs and between worker VMs (DRS need to be enable on the cluster)"
  default     = "false"
}

variable "action" {
  description = "Which action have to be done on the cluster (create, add_worker, remove_worker, or upgrade)"
  default     = "create"
}

variable "worker" {
  type        = list(any)
  description = "List of worker IPs to remove"

  default = [""]
}

variable "vm_user" {
  description = "SSH user for the vSphere virtual machines"
  sensitive = false
}

variable "vm_password" {
  description = "SSH password for the vSphere virtual machines"
  sensitive = true
}

variable "vm_privilege_password" {
  description = "Sudo or su password for the vSphere virtual machines"
  sensitive = true
}

variable "vm_distro" {
  description = "Linux distribution of the vSphere virtual machines (ubuntu/centos/debian/rhel)"
}

variable "vm_datastore" {
  description = "Datastore used for the vSphere virtual machines"
}

variable "vm_network" {
  description = "Network used for the vSphere virtual machines"
}

variable "vm_template" {
  description = "Template used to create the vSphere virtual machines (linked clone)"
}

variable "vm_linked_clone" {
  description = "Use linked clone to create the vSphere virtual machines from the template (true/false). If you would like to use the linked clone feature, your template need to have one and only one snapshot"
  default     = "false"
}

variable "k8s_kubespray_url" {
  description = "Kubespray git repository"
  default     = "https://github.com/kubernetes-incubator/kubespray.git"
}

variable "k8s_kubespray_version" {
  description = "Kubespray version"
  default     = "release-2.28"
}

variable "k8s_version" {
  description = "Version of Kubernetes that will be deployed"
  default     = "1.32.0"
}

variable "vm_master_count" {
  
}
variable "vm_cidr" {
  
}
variable "vm_master_start_ip" {
  
}
variable "vm_master_end_ip" {
  
}

variable "vm_worker_count" {
  
}

variable "vm_worker_start_ip" {
  
}
variable "vm_worker_end_ip" {
  
}

variable "vm_haproxy_count" {
  
}

variable "vm_haproxy_start_ip" {
  
}
variable "vm_haproxy_end_ip" {
  
}

variable "vm_haproxy_vip" {
  description = "IP used for the HAProxy floating VIP"
}

variable "virtual_router_id" {
  
}

variable "project_name" {
}

variable "container_manager" {
  default = "containerd"
}

variable "vm_netmask" {
  description = "Netmask used for the Kubernetes nodes and HAProxy (example: 24)"
}

variable "vm_gateway" {
  description = "Gateway for the Kubernetes nodes"
}

variable "vm_dns" {
  description = "DNS for the Kubernetes nodes"
}

variable "vm_dns_suffix" {
  description = "DNS suffix for the Kubernetes nodes"
}


variable "vm_domain" {
  description = "Domain for the Kubernetes nodes"
}

variable "k8s_network_plugin" {
  description = "Kubernetes network plugin (calico/canal/flannel/weave/cilium/contiv/kube-router)"
  default     = "calico"
}

variable "k8s_dns_mode" {
  description = "Which DNS to use for the internal Kubernetes cluster name resolution (example: kubedns, coredns, etc.)"
  default     = "coredns"
}

variable "vm_master_cpu" {
  description = "Number of vCPU for the Kubernetes master virtual machines"
}

variable "vm_master_ram" {
  description = "Amount of RAM for the Kubernetes master virtual machines (example: 2048)"
}

variable "vm_master_disk_size" {
  description = "Amount of disk size"
}

variable "vm_master_disk_label" {
  description = "Amount of disk size"
  default     = "disk0"
}

variable "vm_master_disk_thin" {
  description = "Amount of disk size"
  default     = true
}

variable "vm_worker_cpu" {
  description = "Number of vCPU for the Kubernetes worker virtual machines"
}

variable "vm_worker_ram" {
  description = "Amount of RAM for the Kubernetes worker virtual machines (example: 2048)"
}

variable "vm_worker_disk_size" {
  description = "Amount of disk size"
}

variable "vm_worker_disk_label" {
  description = "Amount of disk size"
  default     = "disk0" 
}

variable "vm_worker_disk_thin" {
  description = "Amount of disk size"
  default     = true 
}

variable "vm_haproxy_cpu" {
  description = "Number of vCPU for the HAProxy virtual machine"
}

variable "vm_haproxy_ram" {
  description = "Amount of RAM for the HAProxy virtual machine (example: 1024)"
}


variable "vm_name_prefix" {
  description = "Prefix for the name of the virtual machines and the hostname of the Kubernetes nodes"
}
