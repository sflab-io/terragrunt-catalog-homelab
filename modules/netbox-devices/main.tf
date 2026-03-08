resource "netbox_device_role" "this" {
  for_each  = var.device_roles
  name      = each.key
  color_hex = each.value.color_hex
  vm_role   = try(each.value.vm_role, false)
}

resource "netbox_manufacturer" "this" {
  for_each = { for manufacturer in var.manufacturers : manufacturer.name => manufacturer }
  name     = each.value.name
}

resource "netbox_device_type" "this" {
  for_each        = { for device_type in var.device_types : device_type.model => device_type }
  model           = each.value.model
  manufacturer_id = netbox_manufacturer.this[each.value.manufacturer_name].id
  u_height        = each.value.u_height
}

data "netbox_site" "this" {
  for_each = toset([for device in var.devices : device.site_name])
  name     = each.value
}

data "netbox_tenant" "this" {
  for_each = toset([for device in var.devices : device.tenant_name])
  name     = each.value
}

data "netbox_racks" "this" {
  for_each = toset([for device in var.devices : device.rack_name if device.rack_name != null])
  filter {
    name  = "name"
    value = each.value
  }
}

resource "netbox_device" "this" {
  for_each       = { for device in var.devices : device.name => device }
  name           = each.value.name
  device_type_id = netbox_device_type.this[each.value.device_type].id
  role_id        = netbox_device_role.this[each.value.role_name].id
  site_id        = data.netbox_site.this[each.value.site_name].id
  tenant_id      = data.netbox_tenant.this[each.value.tenant_name].id
  rack_id        = each.value.rack_name != null ? data.netbox_racks.this[each.value.rack_name].racks[0].id : null
}

resource "netbox_device_interface" "this" {
  for_each  = { for device in var.devices : device.name => device }
  name      = each.value.interfaces[0].name
  device_id = netbox_device.this[each.value.name].id
  type      = each.value.interfaces[0].type
}

resource "netbox_ip_address" "this" {
  for_each     = { for device in var.devices : device.name => device }
  ip_address   = each.value.interfaces[0].ip_addresses[0].address
  dns_name     = try(each.value.interfaces[0].ip_addresses[0].dns_name, null)
  status       = try(each.value.interfaces[0].ip_addresses[0].status, null)
  description  = try(each.value.interfaces[0].ip_addresses[0].description, null)
  interface_id = netbox_device_interface.this[each.value.name].id
  object_type  = "dcim.interface"
}
