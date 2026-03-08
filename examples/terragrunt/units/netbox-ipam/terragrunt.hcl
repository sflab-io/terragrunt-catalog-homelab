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
  source = "../../../.././/modules/netbox-ipam"
}

inputs = {
  # Devices variables for NetBox IPAM module
  vlans = [
    {
      name        = "Default"
      vid         = 1
      description = "Default VLAN"
    },
    {
      name        = "USER"
      vid         = 10
      description = "User VLAN"
    },
    {
      name        = "IOT"
      vid         = 20
      description = "IoT VLAN"
    },
    {
      name        = "GUEST"
      vid         = 30
      description = "Guest VLAN"
    }
  ]

  prefixes = [
    {
      prefix      = "192.168.1.0/24"
      status      = "active"
      description = "Default prefix"
      vlan_id     = 1
    },
    {
      prefix      = "192.168.10.0/24"
      status      = "active"
      description = "User VLAN prefix"
      vlan_id     = 10
    },
    {
      prefix      = "192.168.20.0/24"
      status      = "active"
      description = "IoT VLAN prefix"
      vlan_id     = 20
    },
    {
      prefix      = "192.168.30.0/24"
      status      = "active"
      description = "Guest VLAN prefix"
      vlan_id     = 30
    }
  ]
}
