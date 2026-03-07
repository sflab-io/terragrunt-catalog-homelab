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
  source = "../../../.././/modules/netbox-devices"
}

inputs = {
  # Devices variables for NetBox devices module
  device_roles = {
    "Hypervisor" = {
      color_hex = "8a2be2"
      vm_role   = false
    }
    "Server" = {
      color_hex = "ffff00"
      vm_role   = true
    }
    "Router" = {
      color_hex = "00ffff"
      vm_role   = false
    }
    "Firewall" = {
      color_hex = "ff00ff"
      vm_role   = false
    }
    "Switch" = {
      color_hex = "00ff00"
      vm_role   = false
    }
    "AP" = {
      color_hex = "0000ff"
      vm_role   = false
    }
    "K8s Control Plane" = {
      color_hex = "ffa500"
      vm_role   = true
    }
    "K8s Worker" = {
      color_hex = "800000"
      vm_role   = true
    }
  }

  manufacturers = [
    {
      name = "GeeekPi"
    }
  ]

}
