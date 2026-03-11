include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  netbox_config = read_terragrunt_config(find_in_parent_folders("provider-netbox-config.hcl"))

  server_url         = local.netbox_config.locals.netbox_server_url
  skip_version_check = local.netbox_config.locals.netbox_skip_version_check
}

# Generate Netbox and restapi provider blocks
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "restapi" {
  uri                  = "${local.server_url}"
  write_returns_object = true

  headers = {
    Authorization = "Token ${get_env("NETBOX_API_TOKEN")}"
    Content-Type  = "application/json"
  }
}

provider "netbox" {
  server_url         = "${local.server_url}"
  skip_version_check = ${local.skip_version_check}
}
EOF
}

terraform {
  source = "../../../.././/modules/netbox-racks"
}

inputs = {
  # Racks variables for NetBox racks module
  manufacturers = [
    {
      name = "GeeekPi"
    }
  ]

  rack_types = [
    {
      model         = "DeskPi RackMate T1"
      manufacturer  = "GeeekPi"
      form_factor   = "4-post-cabinet"
      width         = 10
      u_height      = 8
      starting_unit = 1
    }
  ]

  racks = [
    {
      name      = "Rack 1"
      site_name = "SFLAB Homelab Site"
      status    = "active"
      rack_type = "DeskPi RackMate T1"
    }
  ]
}
