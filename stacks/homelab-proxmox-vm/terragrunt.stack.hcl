locals {
  env = values.env
  app = values.app

  memory    = try(values.memory, 2048)
  cores     = try(values.cores, 2)
  disk_size = try(values.disk_size, 8)
  cpu_type  = try(values.cpu_type, "x86-64-v2-AES")

  network_config = try(values.network_config, { type = "dhcp" })

  record_types = try(values.record_types, { normal = true, wildcard = false })
  zone         = try(values.dns_zone, "home.sflab.io")

  pool_id = try(values.pool_id, "")
  ssh_public_key_path = try(values.ssh_public_key_path, "${get_repo_root()}/keys/admin_id_ecdsa.pub")

  # Netbox-specific values
  cluster_name = try(values.cluster_name, "")
  role_name    = try(values.role_name, "VM")
  tenant_name  = try(values.tenant_name, "")
  site_name    = try(values.site_name, null)

  virtual_machines = try(values.virtual_machines, [
    {
      name         = "${local.env}-${local.app}"
      cluster_name = local.cluster_name
      description  = "Virtual machine for ${local.app} in ${local.env} environment"
      role_name    = local.role_name
      tenant_name  = local.tenant_name
      site_name    = local.site_name
      vcpus        = local.cores
      memory_mb    = local.memory
      disk_size_mb = local.disk_size
    }
  ])
}

unit "proxmox_vm" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/proxmox-vm?ref=${values.version}"

  path = "proxmox-vm"

  values = {
    version = values.version

    env                 = local.env
    app                 = local.app
    memory              = local.memory
    cores               = local.cores
    disk_size           = local.disk_size
    cpu_type            = local.cpu_type
    pool_id             = local.pool_id
    ssh_public_key_path = local.ssh_public_key_path
    network_config      = local.network_config
  }
}

unit "dns" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/dns?ref=${values.version}"

  path = "dns"

  values = {
    version = values.version

    env          = local.env
    app          = local.app
    zone         = local.zone
    record_types = local.record_types
    compute_path = "../proxmox-vm"
  }
}

unit "netbox_virtual_machine" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-virtual-machine?ref=${values.version}"

  path = "netbox-virtual-machine"

  values = {
    version = values.version

    virtual_machines = local.virtual_machines

    dns_path = "../dns"
  }
}
