locals {
  version = "main"

  # pool configuration
  pool_id = "example-stack-pool"

  # VM naming configuration
  env = "dev"
  app = "example-vm"

  # Optional: Customize VM resources
  # memory = 4096  # Memory in MB (default: 2048)
  # cores  = 4     # CPU cores (default: 2)

  # DNS configuration
  zone = "home.sflab.io."

  # SSH key configuration - use absolute path for stack deployments
  ssh_public_key_path = "${get_repo_root()}/keys/admin_id_ecdsa.pub"
}

unit "homelab_proxmox_vm" {
  source = "git::git@github.com:sflab-io/terragrunt-infrastructure-catalog-homelab.git//stacks/homelab-proxmox-vm?ref=${values.version}"

  app = local.app

  memory    = local.memory
  cores     = local.cores
  disk_size = local.disk_size

  network_config = local.network_config

  record_types = local.record_types
  zone         = "home.sflab.io."

  # pool_id = try(values.pool_id, "")

  # ssh_public_key_path = try(values.ssh_public_key_path, "${get_repo_root()}/keys/admin_id_ecdsa.pub")
}
