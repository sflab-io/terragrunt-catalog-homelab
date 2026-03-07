resource "netbox_manufacturer" "this" {
  for_each = { for manufacturer in var.manufacturers : manufacturer.name => manufacturer }
  name     = each.value.name
}

resource "netbox_rack_type" "this" {
  for_each        = { for rack_type in var.rack_types : rack_type.model => rack_type }
  model           = each.value.model
  manufacturer_id = netbox_manufacturer.this[each.value.manufacturer].id
  form_factor     = each.value.form_factor
  width           = each.value.width
  u_height        = each.value.u_height
  starting_unit   = each.value.starting_unit
}

data "netbox_site" "this" {
  for_each = toset([for rack in var.racks : rack.site_name])
  name     = each.value
}

resource "netbox_rack" "this" {
  for_each = { for rack in var.racks : rack.name => rack }
  name     = each.value.name
  site_id  = data.netbox_site.this[each.value.site_name].id
  status   = each.value.status
}
