locals {
  version = "feat/netbox"

  region_name = "sflab Homelab Region"
  region_description = "Region for sflab homelab infrastructure"
}

unit "netbox" {
  source = "../../../../units/netbox"

  path = "netbox"

  values = {
    version = local.version

    region_name = local.region_name
    region_description = local.region_description

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
