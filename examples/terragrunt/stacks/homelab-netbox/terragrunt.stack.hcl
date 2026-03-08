locals {
  # version = "feat/netbox_stack"
  version = "main"

  # Variables for NetBox organization module
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

  # Variables for NetBox racks module

  # Required by the rack_type_assignment workaround in the module.
  # Passed explicitly because modules cannot read provider configuration directly.
  netbox_url = local.server_url

  # Racks variables for NetBox racks module
  manufacturers = [
    {
      name = "GeeekPi"
    }
  ]

  rack_types = [
    {
      model         = "DeskPi RackMate T1"
      manufacturer  = "GeeekPi"
      form_factor   = "4-post-cabinet"
      width         = 10
      u_height      = 8
      starting_unit = 1
    }
  ]

  racks = [
    {
      name      = "Rack 1"
      site_name = "SFLAB Homelab Site"
      status    = "active"
      rack_type = "DeskPi RackMate T1"
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

unit "netbox_racks" {
  source = "../../../../units/netbox-racks"

  path = "netbox_racks"

  values = {
    version = local.version

    # netbox_url    = local.netbox_url
    manufacturers = local.manufacturers
    rack_types    = local.rack_types
    racks         = local.racks
  }
}
