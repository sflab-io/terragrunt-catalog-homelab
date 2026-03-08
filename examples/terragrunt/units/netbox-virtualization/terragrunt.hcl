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
  source = "../../../.././/modules/netbox-virtualization"
}

inputs = {
  # Variables for NetBox virtualization module
  cluster_types = [
    {
      name = "Proxmox VE Cluster"
    }
  ]

  netbox_clusters = [
    {
      name              = "Proxmox Production Cluster"
      cluster_type_name = "Proxmox VE Cluster"
      site_name         = "SFLAB Homelab Site"
      tenant_name       = "Platform Team"
    },
    {
      name              = "Proxmox Staging Cluster"
      cluster_type_name = "Proxmox VE Cluster"
      site_name         = "SFLAB Homelab Site"
      tenant_name       = "Platform Team"
    }
  ]
}
