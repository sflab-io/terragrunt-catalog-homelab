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
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//modules/netbox-racks?ref=${values.version}"
}

dependency "netbox_organization" {
  config_path = values.organization_path

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs                            = {}
  skip_outputs                            = true
}

inputs = {
  # Required values for NetBox organization module
  netbox_url    = include.provider_netbox.locals.netbox_server_url
  manufacturers = try(values.manufacturers, [])
  rack_types    = try(values.rack_types, [])
  racks         = try(values.racks, [])
}
