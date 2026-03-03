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
  }

  cluster_types = ["Kubernetes", "Proxmox"]
  clusters      = [
    {
      name         = "k8s-cluster-01"
      cluster_type = "Kubernetes"
    },
    {
      name         = "proxmox-cluster-01"
      cluster_type = "Proxmox"
      # cluster_group_id = 1
    }
  ]

  # Optional inputs
  # ...
}
