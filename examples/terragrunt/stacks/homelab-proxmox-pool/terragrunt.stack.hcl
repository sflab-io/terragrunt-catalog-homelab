locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  # version = "main"

  # pool configuration
  # pool_id = "example-stack-pool"
}

unit "proxmox_pool" {
  source = "../../../../units/proxmox-pool"

  path = "proxmox-pool"

  values = {
    version = local.env.catalog_version

    pool_id = local.env.pool_id
  }
}
