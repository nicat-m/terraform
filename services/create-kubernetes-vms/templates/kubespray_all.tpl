## Directory where etcd data stored
etcd_data_dir: /var/lib/etcd

## Directory where the binaries will be installed
bin_dir: /usr/local/bin

## The access_ip variable is used to define how other nodes should access
## the node.  This is used in flannel to allow other flannel nodes to see
## this node for example.  The access_ip is really useful AWS and Google
## environments where the nodes are accessed remotely by the "public" ip,
## but don't know about that address themselves.
#access_ip: 1.1.1.1


## External LB example config
apiserver_loadbalancer_domain_name: "${loadbalancer_apiserver}"
loadbalancer_apiserver:
  address: "${loadbalancer_apiserver}"
  port: 6443

## Internal loadbalancers for apiservers
#loadbalancer_apiserver_localhost: true

## Local loadbalancer should use this port instead, if defined.
## Defaults to kube_apiserver_port (6443)
#nginx_kube_apiserver_port: 8443

### OTHER OPTIONAL VARIABLES
## For some things, kubelet needs to load kernel modules.  For example, dynamic kernel services are needed
## for mounting persistent volumes into containers.  These may not be loaded by preinstall kubernetes
## processes.  For example, ceph and rbd backed volumes.  Set to true to allow kubelet to load kernel
## modules.
#kubelet_load_modules: false

## Upstream dns servers used by dnsmasq
#upstream_dns_servers:
#  - 8.8.8.8
#  - 8.8.4.4

## There are some changes specific to the cloud providers
## for instance we need to encapsulate packets with some network plugins
## If set the possible values are either 'gce', 'aws', 'azure', 'openstack', 'vsphere', 'oci', or 'external'
## When openstack is used make sure to source in the openstack credentials
## like you would do when using nova-client before starting the playbook.
## Note: The 'external' cloud provider is not supported. 
## TODO(riverzhang): https://kubernetes.io/docs/tasks/administer-cluster/running-cloud-controller/#running-cloud-controller-manager
cloud_provider:  "vsphere"
vsphere_vcenter_ip: "${vsphere_vcenter_ip}"
vsphere_vcenter_port: 443
vsphere_insecure: 1
vsphere_user: "${vsphere_user}"
vsphere_password: "${vsphere_password}"
vsphere_datacenter: "${vsphere_datacenter}"
vsphere_datastore: "${vsphere_datastore}"
vsphere_working_dir: "${vsphere_working_dir}"
vsphere_scsi_controller_type: "pvscsi"
vsphere_resource_pool: "${vsphere_resource_pool}"

## kubeadm deployment mode
kubeadm_enabled: true

# Skip alert information
skip_non_kubeadm_warning: false

## Set these proxy values in order to update package manager and docker daemon to use proxies
#http_proxy: ""
#https_proxy: ""

## Refer to roles/kubespray-defaults/defaults/main.yml before modifying no_proxy
#no_proxy: ""

## Some problems may occur when downloading files over https proxy due to ansible bug
## https://github.com/ansible/ansible/issues/32750. Set this variable to False to disable
## SSL validation of get_url module. Note that kubespray will still be performing checksum validation.
#download_validate_certs: False

## If you need exclude all cluster nodes from proxy and other resources, add other resources here.
#additional_no_proxy: ""

## Certificate Management
## This setting determines whether certs are generated via scripts.
## Chose 'none' if you provide your own certificates.
## Option is  "script", "none"
## note: vault is removed
#cert_management: script

## Set to true to allow pre-checks to fail and continue deployment
#ignore_assert_errors: false

## The read-only port for the Kubelet to serve on with no authentication/authorization. Uncomment to enable.
#kube_read_only_port: 10255

## Set true to download and cache container
#download_container: true

## Deploy container engine
# Set false if you want to deploy container engine manually.
#deploy_container_engine: true

## Set Pypi repo and cert accordingly
#pyrepo_index: https://pypi.example.com/simple
#pyrepo_cert: /etc/ssl/certs/ca-certificates.crt
