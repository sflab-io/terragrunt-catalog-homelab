locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals

  app     = "wc-test"

  record_types = {
    normal   = true
    wildcard = true
  }
}

unit "proxmox_lxc" {
  source = "../../../../units/proxmox-lxc"

  path   = "proxmox-lxc"

  values = {
    version  = local.env.catalog_version
    env      = local.env.environment_name
    app      = local.app
    pool_id  = local.env.pool_id
  }
}

unit "dns" {
  source = "../../../../units/dns"

  path   = "dns"

  values = {
    version      = local.env.catalog_version
    env          = local.env.environment_name
    app          = local.app
    zone         = local.env.zone
    record_types = local.record_types
    compute_path = "../proxmox-lxc"
  }
}
