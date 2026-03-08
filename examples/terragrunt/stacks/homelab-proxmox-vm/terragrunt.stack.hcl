locals {
  version = "feat/better_stacks"

  # pool configuration
  pool_id = "example-stack-pool"

  # VM naming configuration
  env = "dev"
  app = "example-vm"

  # DNS configuration
  zone = "home.sflab.io."

  # SSH key configuration - use absolute path for stack deployments
  ssh_public_key_path = "${get_repo_root()}/keys/admin_id_ecdsa.pub"
}

unit "proxmox_vm" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/proxmox-vm?ref=${local.version}"

  path = "proxmox-vm"

  values = {
    version = local.version

    env     = local.env
    app     = local.app
    pool_id = local.pool_id

    # Optional: Customize VM resources
    # memory    = 4096
    # cores     = 4
    # disk_size = 20

    ssh_public_key_path = local.ssh_public_key_path

    network_config = { type = "dhcp" }
  }
}

unit "dns" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/dns?ref=${local.version}"

  path = "dns"

  values = {
    version = local.version

    env  = local.env
    app  = local.app
    zone = local.zone

    compute_path = "../proxmox-vm"
  }
}
