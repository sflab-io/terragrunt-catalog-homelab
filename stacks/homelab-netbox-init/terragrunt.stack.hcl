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
  rack_manufacturers = values.rack_manufacturers
  rack_types         = values.rack_types
  racks         = values.racks

  # Variables for NetBox devices module
  device_roles         = values.device_roles
  device_manufacturers = values.device_manufacturers
  device_types         = values.device_types
  devices              = values.devices

  # Variables for NetBox IPAM module
  vlans    = values.vlans
  prefixes = values.prefixes

  # Variables for NetBox virtualization module
  cluster_types = values.cluster_types
  clusters      = values.clusters

  # Variables for NetBox wireless module
  wireless_lans = values.wireless_lans
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

    manufacturers = local.rack_manufacturers
    rack_types    = local.rack_types
    racks         = local.racks
  }
}

unit "netbox_devices" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-devices?ref=${values.version}"

  path = "netbox_devices"

  values = {
    version = values.version

    racks_path = "../netbox_racks"

    device_roles  = local.device_roles
    manufacturers = local.device_manufacturers
    device_types  = local.device_types
    devices       = local.devices
  }
}

unit "netbox_ipam" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-ipam?ref=${values.version}"

  path = "netbox_ipam"

  values = {
    version = values.version

    devices_path = "../netbox_devices"

    vlans    = local.vlans
    prefixes = local.prefixes
  }
}

unit "netbox_virtualization" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-virtualization?ref=${values.version}"

  path = "netbox_virtualization"

  values = {
    version = values.version

    ipam_path = "../netbox_ipam"

    cluster_types = local.cluster_types
    clusters      = local.clusters
  }
}

unit "netbox_wireless" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-wireless?ref=${values.version}"

  path = "netbox_wireless"

  values = {
    version = values.version

    ipam_path     = "../netbox_ipam"

    wireless_lans = local.wireless_lans
  }
}
