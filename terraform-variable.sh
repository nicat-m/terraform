#!/usr/bin/env


#===============================================================================
# VMware vSphere configuration
#===============================================================================

# vCenter IP or FQDN #
export TF_VAR_vsphere_vcenter=''

# vSphere username & password used to deploy the infrastructure #
export TF_VAR_vsphere_user=''
export TF_VAR_vsphere_password=''


#===============================================================================
# Global virtual machines parameters
#===============================================================================

# Username used to SSH to the virtual machines #
export TF_VAR_vm_user=''
export TF_VAR_vm_password=''
export TF_VAR_vm_privilege_password=''
