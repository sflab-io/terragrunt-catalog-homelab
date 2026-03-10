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
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//modules/netbox-virtual-machine?ref=${values.version}"
}

dependency "netbox_virtualization" {
  config_path = values.virtualization_path

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs                            = {}
  skip_outputs                            = true
}

inputs = {
  virtual_machines = values.virtual_machines
}
