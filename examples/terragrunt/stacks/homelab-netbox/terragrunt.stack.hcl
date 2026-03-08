locals {
  version = "main"

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

unit "netbox_organization" {
  source = "../../../../units/netbox-organization"

  path = "netbox_organization"

  values = {
    version = local.version

    regions = local.regions
    sites   = local.sites
    tenant_groups = local.tenant_groups
    tenants = local.tenants
    contact_groups = local.contact_groups
    contact_roles = local.contact_roles
    contacts = local.contacts
  }
}
