locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals

  # Variables for NetBox organization module
  virtual_machines = [
    {
      name              = "Example VM"
      cluster_name      = "Proxmox Cluster Production"
      role_name         = "VM"
      tenant_name       = "Platform Team"
      vcpus             = 2
      memory_mb         = 4096
      disk_size_mb      = 8000
      interfaces        = [
        {
          name     = "eth0"
          address  = "192.168.1.99/32"
          status   = "active"
          dns_name = "example.home.sflab.local"
        }
      ]
    }
  ]
}

stack "netbox_virtual_machine" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//stacks/homelab-netbox-virtual-machine?ref=${local.env.catalog_version}"

  path = "netbox_virtual_machine"

  values = {
    version = local.env.catalog_version

    # Required values for NetBox virtual machine module
    virtual_machines = local.virtual_machines
  }
}
