locals {
  env     = values.env
  app     = values.app
  pool_id = try(values.pool_id, "")

  memory    = try(values.memory, 2048)
  cores     = try(values.cores, 2)
  disk_size = try(values.disk_size, 8)

  ssh_public_key_path = try(values.ssh_public_key_path, "${get_repo_root()}/keys/admin_id_ecdsa.pub")

  network_config = try(values.network_config, { type = "dhcp" })

  zone         = try(values.dns_zone, "home.sflab.io.")
  record_types = try(values.record_types, { normal = true, wildcard = false })
}

unit "proxmox_vm" {
  source = "git::git@github.com:sflab-io/terragrunt-infrastructure-catalog-homelab.git//units/proxmox-vm?ref=${values.version}"

  path = "proxmox-vm"

  values = {
    version             = values.version
    env                 = local.env
    app                 = local.app
    memory              = local.memory
    cores               = local.cores
    disk_size           = local.disk_size
    pool_id             = local.pool_id
    ssh_public_key_path = local.ssh_public_key_path
    network_config      = local.network_config
  }
}

unit "dns" {
  source = "git::git@github.com:sflab-io/terragrunt-infrastructure-catalog-homelab.git//units/dns?ref=${values.version}"

  path = "dns"

  values = {
    version      = values.version
    env          = local.env
    app          = local.app
    zone         = local.zone
    record_types = local.record_types
    compute_path = "../proxmox-vm"
  }
}
