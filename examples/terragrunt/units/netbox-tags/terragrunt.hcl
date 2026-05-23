include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  netbox_config      = read_terragrunt_config(find_in_parent_folders("provider-netbox-config.hcl"))
  server_url         = local.netbox_config.locals.netbox_server_url
  skip_version_check = local.netbox_config.locals.netbox_skip_version_check
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "netbox" {
  server_url         = "${local.server_url}"
  skip_version_check = ${local.skip_version_check}
}
EOF
}

terraform {
  source = "../../../.././/modules/netbox-tags"
}

inputs = {
  tags = ["example-lxc", "example-vm"]
}
