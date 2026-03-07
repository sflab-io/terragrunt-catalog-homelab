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
  source = "../../../.././/modules/netbox-organization"
}

inputs = {
  # Sites and regions variables for NetBox organization module
  regions = [
    {
      name        = "SFLAB Homelab Region"
      description = "SFLAB Homelab Region Description"
    }
  ]

  sites = [
    {
      name        = "SFLAB Homelab Site"
      facility    = "SFLAB Homelab Facility"
      latitude    = "48.7844"
      longitude   = "9.2078"
      timezone    = "Europe/Berlin"
      region_name = "SFLAB Homelab Region"
    }
  ]

  # Tenant and contact variables for NetBox organization module
  tenant_groups = [
    {
      name = "internal"
    }
  ]

  tenants = [
    {
      name       = "Platform Team"
      group_name = "internal"
    }
  ]

  contact_groups = [
    {
      name = "Platform Team Contacts"
    }
  ]

  contact_roles = [
    {
      name = "Business Contact"
    },
    {
      name = "Private Contact"
    }
  ]


  contacts = [
    {
      name       = "Sebastian Freund"
      email      = "abes140377@web.de"
      phone      = "123-123123"
      group_name = "Platform Team Contacts"
      role_name  = "Business Contact"
    }
  ]

}
