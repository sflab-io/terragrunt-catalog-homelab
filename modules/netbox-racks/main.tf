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

# The e-breuninger/netbox provider does not support setting rack_type on
# netbox_rack resources. This workaround uses the NetBox REST API directly via
# curl to PATCH the rack after creation.
#
# Prerequisites:
#   - NETBOX_API_TOKEN environment variable must be set (same token used by the provider)
#   - var.netbox_url must be set (e.g. "http://netbox.home.sflab.io")
#   - curl must be available on the system running tofu
#
# Behaviour:
#   - Only runs for racks where rack_type is set (non-null)
#   - Re-runs automatically when the rack ID or rack type ID changes (triggers_replace)
#   - Does NOT reset rack_type on destroy (rack is deleted entirely anyway)
resource "terraform_data" "rack_type_assignment" {
  for_each = { for rack in var.racks : rack.name => rack if rack.rack_type != null }

  triggers_replace = [
    netbox_rack.this[each.key].id,
    netbox_rack_type.this[each.value.rack_type].id,
  ]

  provisioner "local-exec" {
    command = <<-EOT
      curl -sf -X PATCH \
        -H "Authorization: Token $NETBOX_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"rack_type": ${netbox_rack_type.this[each.value.rack_type].id}}' \
        "${var.netbox_url}/api/dcim/racks/${netbox_rack.this[each.key].id}/"
    EOT
  }
}
