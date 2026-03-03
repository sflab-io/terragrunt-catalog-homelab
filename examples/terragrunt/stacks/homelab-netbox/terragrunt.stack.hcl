locals {
  version = "feat/netbox"

  # # pool configuration
  # pool_id = "example-stack-pool"

  # # VM naming configuration
  # env = "dev"
  # app = "example-vm"

  # # Optional: Customize VM resources
  # # memory = 4096  # Memory in MB (default: 2048)
  # # cores  = 4     # CPU cores (default: 2)

  # # DNS configuration
  # zone = "home.sflab.io."

  # # SSH key configuration - use absolute path for stack deployments
  # ssh_public_key_path = "${get_repo_root()}/keys/admin_id_ecdsa.pub"
}

unit "netbox" {
  source = "../../../../units/netbox"

  path = "netbox"

  values = {
    version = local.version

    # env     = local.env
    # app     = "${local.app}-1"
    # pool_id = local.pool_id

    # # SSH key path
    # ssh_public_key_path = local.ssh_public_key_path

    # # Optional: Customize VM resources
    # # memory = try(local.memory, 2048)
    # # cores  = try(local.cores, 2)
    # network_config = {
    #   type        = "static"
    #   ip_address  = "192.168.1.33"
    #   cidr        = 24
    #   gateway     = "192.168.1.1"
    #   # dns_servers = ["8.8.8.8", "8.8.4.4"]  # Optional
    # }
  }
}
