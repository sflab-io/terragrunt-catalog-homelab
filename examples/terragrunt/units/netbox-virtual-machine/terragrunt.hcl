include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  netbox_config    = read_terragrunt_config(find_in_parent_folders("provider-netbox-config.hcl"))

  server_url         = local.netbox_config.locals.netbox_server_url
  skip_version_check = local.netbox_config.locals.netbox_skip_version_check
}

# Generate Netbox provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "netbox" {
  server_url         = "${local.server_url}"
  skip_version_check = ${local.skip_version_check}
}
EOF
}

terraform {
  source = "../../../.././/modules/netbox-virtual-machine"
}

inputs = {
  # Variables for NetBox virtual machine module
  virtual_machines = [
    # {
    #   name         = "minio"
    #   cluster_name = "Proxmox Production Cluster"
    #   role_name    = "LXC"
    #   tenant_name  = "Platform Team"
    #   vcpus        = 2
    #   memory_mb    = 2048
    #   disk_size_mb = 8000
    #   interfaces = [
    #     {
    #       name     = "eth0"
    #       address  = "192.168.1.33"
    #       status   = "active"
    #       dns_name = "minio.home.sflab.local"
    #     }
    #   ]
    # },
    {
      name         = "vault"
      cluster_name = "Proxmox Production Cluster"
      role_name    = "VM"
      tenant_name  = "Platform Team"
      vcpus        = 2
      memory_mb    = 4096
      disk_size_mb = 8000
      interfaces   = [
        {
          name     = "eth0"
          address  = "192.168.1.34/32"
          status   = "active"
          dns_name = "vault.home.sflab.local"
        }
      ]
    },
    {
      name         = "netbox"
      cluster_name = "Proxmox Production Cluster"
      role_name    = "VM"
      tenant_name  = "Platform Team"
      vcpus        = 2
      memory_mb    = 4096
      disk_size_mb = 16000
      interfaces   = [
        {
          name     = "eth0"
          address  = "192.168.1.89/32"
          status   = "active"
          dns_name = "netbox.home.sflab.local"
        }
      ]
    },
    {
      name         = "docker"
      cluster_name = "Proxmox Production Cluster"
      role_name    = "VM"
      tenant_name  = "Platform Team"
      vcpus        = 2
      memory_mb    = 2048
      disk_size_mb = 8000
      interfaces   = [
        {
          name     = "eth0"
          address  = "192.168.1.198/32"
          status   = "active"
          dns_name = "docker.home.sflab.local"
        }
      ]
    },
  ]
}
