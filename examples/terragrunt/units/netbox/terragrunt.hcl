include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  netbox_config    = read_terragrunt_config(find_in_parent_folders("provider-netbox-config.hcl"))

  server_url         = local.netbox_config.locals.netbox_server_url
  skip_version_check = local.netbox_config.locals.netbox_skip_version_check
}

# Generate Netbox provider block
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
  source = "../../../.././/modules/netbox"
}

inputs = {
  # Required inputs
  region_name        = "sflab Homelab Region"
  region_description = "sflab Homelab Region Description"

  site_name      = "sflab Homelab Site"
  site_facility  = "sflab Homelab Facility"
  site_latitude  = "48.7844"
  site_longitude = "9.2078"
  timezone       = "Europe/Berlin"

  # Optional inputs
  # ...
}
