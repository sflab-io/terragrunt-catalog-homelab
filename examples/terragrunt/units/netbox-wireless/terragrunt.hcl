include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  netbox_config = read_terragrunt_config(find_in_parent_folders("provider-netbox-config.hcl"))

  server_url         = local.netbox_config.locals.netbox_server_url
  skip_version_check = local.netbox_config.locals.netbox_skip_version_check
}

# Generate Netbox provider block
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
EOF
}

terraform {
  source = "../../../.././/modules/netbox-wireless"
}

inputs = {
  # Required values for NetBox wireless module
  netbox_url = local.server_url

  wireless_lans = [
    {
      ssid        = "HomeNet"
      description = "Primary home network"
      status      = "active"
      auth_type   = "wpa-personal"
      auth_cipher = "aes"
      auth_psk    = "super-secret-passphrase"
      # tags        = ["homelab"]
    },
    {
      ssid   = "HomeNet-Guest"
      status = "active"
    },
  ]
}
