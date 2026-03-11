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

  # Ensure racks are destroyed before rack_types on `tofu destroy`.
  # NetBox rejects deleting a rack_type that still has racks referencing it.
  depends_on = [netbox_rack_type.this]
}

# The e-breuninger/netbox provider does not support setting rack_type on
# netbox_rack resources. This workaround uses the Mastercard/restapi provider to
# PATCH the rack after creation via the NetBox REST API.
#
# Behaviour:
#   - Only runs for racks where rack_type is set (non-null)
#   - Re-runs automatically when rack_type changes
#   - Destroy is a no-op GET (rack is deleted entirely by netbox_rack.this anyway)
resource "restapi_object" "rack_type_assignment" {
  for_each = { for rack in var.racks : rack.name => rack if rack.rack_type != null }

  path         = "/api/dcim/racks/"
  create_path  = "/api/dcim/racks/${netbox_rack.this[each.key].id}/"
  destroy_path = "/api/dcim/racks/${netbox_rack.this[each.key].id}/"

  create_method  = "PATCH"
  update_method  = "PATCH"
  destroy_method = "GET"

  data         = jsonencode({ rack_type = netbox_rack_type.this[each.value.rack_type].id })
  id_attribute = "id"

  depends_on = [netbox_rack.this, netbox_rack_type.this]
}
