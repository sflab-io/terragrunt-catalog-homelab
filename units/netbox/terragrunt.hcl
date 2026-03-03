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
provider "netbox" {
  server_url         = "${include.provider_netbox.locals.netbox_server_url}"
  skip_version_check = ${include.provider_netbox.locals.netbox_skip_version_check}
}
EOF
}

terraform {
  source = "git::git@github.com:sflab-io/terragrunt-infrastructure-catalog-homelab.git//modules/netbox?ref=${values.version}"
}

inputs = {
  # Required inputs
  # env = values.env
  # app = values.app
  # zone = values.zone

  # Optional inputs
  netbox_region_name = values.netbox_region_name
  netbox_region_description = values.netbox_region_description
}
