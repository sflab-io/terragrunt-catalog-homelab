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
  region_name = values.region_name
  region_description = values.region_description

  site_name = values.site_name
  site_facility = values.site_facility
  site_latitude = values.site_latitude
  site_longitude = values.site_longitude
  timezone = values.timezone

  device_roles = values.device_roles

  cluster_types = values.cluster_types
  clusters = values.clusters

  # Optional inputs
  # ...
}
