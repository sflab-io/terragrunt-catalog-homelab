locals {
  regions        = values.regions
  sites          = values.sites
  tenant_groups  = values.tenant_groups
  tenants        = values.tenants
  contact_groups = values.contact_groups
  contact_roles  = values.contact_roles
  contacts       = values.contacts
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
