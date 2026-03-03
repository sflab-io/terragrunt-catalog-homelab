locals {
  version = "feat/netbox"

  netbox_region_name = "sflab Homelab Region"
  netbox_region_description = "Region for sflab homelab infrastructure"
}

unit "netbox" {
  source = "../../../../units/netbox"

  path = "netbox"

  values = {
    version = local.version

    netbox_region_name = local.netbox_region_name
    netbox_region_description = local.netbox_region_description

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
