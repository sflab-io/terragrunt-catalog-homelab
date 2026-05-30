include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  netbox_config      = read_terragrunt_config(find_in_parent_folders("provider-netbox-config.hcl"))
  server_url         = local.netbox_config.locals.netbox_server_url
  skip_version_check = local.netbox_config.locals.netbox_skip_version_check
  netbox_token       = local.netbox_config.locals.netbox_token
}

# Generate Netbox provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "netbox" {
  server_url         = "${local.server_url}"
  skip_version_check = ${local.skip_version_check}
  token              = "${local.netbox_token}"
}
EOF
}

terraform {
  source = "../../../.././/modules/netbox-virtual-machine"
}

inputs = {
  virtual_machines = [
    {
      name         = "example-vm-a"
      cluster_name = "proxmox-production"
      role_name    = "VM"
      tenant_name  = "platform-team"
      vcpus        = 2
      memory_mb    = 2048
      disk_size_mb = 8000
      interfaces = [
        {
          name     = "eth0"
          address  = "10.99.99.10/32"
          status   = "active"
          dns_name = "example-vm-a.home.sflab.io"
        }
      ]
    },
    {
      name         = "example-vm-b"
      cluster_name = "proxmox-production"
      role_name    = "VM"
      tenant_name  = "platform-team"
      vcpus        = 2
      memory_mb    = 2048
      disk_size_mb = 8000
      interfaces = [
        {
          name     = "eth0"
          address  = "10.99.99.11/32"
          status   = "active"
          dns_name = "example-vm-b.home.sflab.io"
        }
      ]
    },
  ]
}
