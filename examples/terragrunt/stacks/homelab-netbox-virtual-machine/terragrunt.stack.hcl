locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals

  virtual_machines = [
    {
      name         = "example-netbox-vm-staging"
      cluster_name = "Proxmox Cluster Production"
      role_name    = "VM"
      tenant_name  = "Platform Team"
      vcpus        = 2
      memory_mb    = 2048
      disk_size_mb = 8000
      tags         = ["example-netbox-vm-staging"]
      extra_tags   = []
      interfaces = [
        {
          name     = "eth0"
          address  = "192.168.1.200/32"
          dns_name = "example-netbox-vm-staging.home.sflab.io"
          status   = "active"
        }
      ]
    }
  ]
}

stack "homelab_netbox_virtual_machine" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//stacks/homelab-netbox-virtual-machine?ref=${local.env.catalog_version}"

  path = "homelab-netbox-virtual-machine"

  values = {
    version          = local.env.catalog_version
    virtual_machines = local.virtual_machines
  }
}
