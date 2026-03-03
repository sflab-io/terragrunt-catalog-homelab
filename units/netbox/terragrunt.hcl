include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider_netbox" {
  path = find_in_parent_folders("provider-netbox-config.hcl")
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
}
