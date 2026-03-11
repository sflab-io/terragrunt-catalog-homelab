include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider_netbox" {
  path   = find_in_parent_folders("provider-netbox-config.hcl")
  expose = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "restapi" {
  uri                  = "${include.provider_netbox.locals.netbox_server_url}"
  write_returns_object = true

  headers = {
    Authorization = "Token ${get_env("NETBOX_API_TOKEN")}"
    Content-Type  = "application/json"
  }
}

provider "netbox" {
  server_url         = "${include.provider_netbox.locals.netbox_server_url}"
  skip_version_check = ${include.provider_netbox.locals.netbox_skip_version_check}
}
EOF
}

terraform {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//modules/netbox-wireless?ref=${values.version}"
}

inputs = {
  # Required values for NetBox wireless module
  netbox_url    = include.provider_netbox.locals.netbox_server_url
  wireless_lans = try(values.wireless_lans, [])
}
