resource "netbox_region" "this" {
  for_each    = { for region in var.regions : region.name => region }
  name        = each.value.name
  description = each.value.description
}

resource "netbox_site" "this" {
  for_each  = { for site in var.sites : site.name => site }
  name      = each.value.name
  facility  = each.value.facility
  latitude  = each.value.latitude
  longitude = each.value.longitude
  timezone  = each.value.timezone
  status    = "active"
  region_id = lookup(netbox_region.this, each.value.region_name, null).id
}

resource "netbox_tenant_group" "this" {
  for_each = { for tenant_group in var.tenant_groups : tenant_group.name => tenant_group }
  name     = each.value.name
}

resource "netbox_tenant" "this" {
  for_each = { for tenant in var.tenants : tenant.name => tenant }
  name     = each.value.name
  group_id = try(netbox_tenant_group.this[each.value.group_name].id, null)
}

resource "netbox_contact_group" "this" {
  for_each = { for contact_group in var.contact_groups : contact_group.name => contact_group }
  name     = each.value.name
}

resource "netbox_contact_role" "this" {
  for_each = { for contact_role in var.contact_roles : contact_role.name => contact_role }
  name     = each.value.name
}

resource "netbox_contact" "this" {
  for_each = { for contact in var.contacts : contact.name => contact }
  name     = each.value.name
  email    = each.value.email
  phone    = each.value.phone
  # seems like group_id of netbox_contact is buggy and doesn't set the group reference in the UI, even if the API call is correct.
  # need to investigate further.
  group_id = try(netbox_contact_group.this[each.value.group_name].id, null)
}
