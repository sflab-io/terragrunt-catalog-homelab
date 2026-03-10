locals {
  # Variables for NetBox organization module
  regions        = values.regions
  sites          = values.sites
  tenant_groups  = values.tenant_groups
  tenants        = values.tenants
  contact_groups = values.contact_groups
  contact_roles  = values.contact_roles
  contacts       = values.contacts

  # Variables for NetBox racks module
  manufacturers = values.manufacturers
  rack_types    = values.rack_types
  racks         = values.racks
}

unit "netbox_organization" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-organization?ref=${values.version}"

  path = "netbox_organization"

  values = {
    version = values.version

    regions        = local.regions
    sites          = local.sites
    tenant_groups  = local.tenant_groups
    tenants        = local.tenants
    contact_groups = local.contact_groups
    contact_roles  = local.contact_roles
    contacts       = local.contacts
  }
}

unit "netbox_racks" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-racks?ref=${values.version}"

  path = "netbox_racks"

  values = {
    version = values.version

    organization_path = "../netbox_organization"

    manufacturers = local.manufacturers
    rack_types    = local.rack_types
    racks         = local.racks
  }
}

# unit "netbox_devices" {
#   source = "../../../../units/netbox-devices"

#   path = "netbox_devices"

#   values = {
#     version = local.env.catalog_version

#     racks_path = "../netbox_racks"

#     device_roles  = local.device_roles
#     manufacturers = local.manufacturers_devices
#     device_types  = local.device_types
#     devices       = local.devices
#   }
# }

# unit "netbox_ipam" {
#   source = "../../../../units/netbox-ipam"

#   path = "netbox_ipam"

#   values = {
#     version = local.env.catalog_version

#     devices_path = "../netbox_devices"

#     vlans    = local.vlans
#     prefixes = local.prefixes
#   }
# }

# unit "netbox_virtualization" {
#   source = "../../../../units/netbox-virtualization"

#   path = "netbox_virtualization"

#   values = {
#     version = local.env.catalog_version

#     ipam_path = "../netbox_ipam"

#     cluster_types   = local.cluster_types
#     netbox_clusters = local.netbox_clusters
#   }
# }
