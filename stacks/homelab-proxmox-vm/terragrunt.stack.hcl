locals {
  # env     = values.env
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals

  app = values.app

  memory    = try(values.memory, 2048)
  cores     = try(values.cores, 2)
  disk_size = try(values.disk_size, 8)

  network_config = try(values.network_config, { type = "dhcp" })

  record_types = try(values.record_types, { normal = true, wildcard = false })
  zone         = try(values.dns_zone, "home.sflab.io.")

  pool_id = try(values.pool_id, "")

  ssh_public_key_path = try(values.ssh_public_key_path, "${get_repo_root()}/keys/admin_id_ecdsa.pub")
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

# unit "netbox_virtual_machine" {
#   source = "git::git@github.com:sflab-io/terragrunt-infrastructure-catalog-homelab.git//units/netbox-virtual-machine?ref=${values.version}"

#   path = "netbox-virtual-machine"

#   values = {
#     version      = values.version

#     virtual_machines = [
#       {
#         name         = "vault"
#         cluster_name = "Proxmox Production Cluster"
#         role_name    = "VM"
#         tenant_name  = "Platform Team"
#         vcpus        = 2
#         memory_mb    = 4096
#         disk_size_mb = 8000
#         interfaces   = [
#           {
#             name     = "eth0"
#             address  = "192.168.1.34/32"
#             status   = "active"
#             dns_name = "vault.home.sflab.local"
#           }
#         ]
#       },
#     ]

#     # env          = local.env
#     # app          = local.app
#     # zone         = local.zone
#     # record_types = local.record_types
#     # compute_path = "../proxmox-vm"
#   }
# }
