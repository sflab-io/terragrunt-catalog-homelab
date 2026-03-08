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
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//modules/netbox-organization?ref=${values.version}"
}

inputs = {
  # Required values for NetBox organization module
  regions = values.regions
  sites   = values.sites

  tenant_groups  = try(values.tenant_groups, [])
  tenants        = try(values.tenants, [])
  contact_groups = try(values.contact_groups, [])
  contact_roles  = try(values.contact_roles, [])
  contacts       = try(values.contacts, [])
}
