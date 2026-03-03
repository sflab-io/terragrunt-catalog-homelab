resource "netbox_region" "this" {
  name        = var.netbox_region_name
  description = var.netbox_region_description
}

resource "netbox_site" "this" {
  name      = var.netbox_site_name
  facility  = var.netbox_site_facility
  latitude  = var.netbox_site_latitude
  longitude = var.netbox_site_longitude
  status    = "active"
  timezone  = var.netbox_timezone
  region_id = netbox_region.this.id
}

resource "netbox_device_role" "this" {
  for_each  = var.device_roles
  name      = each.key
  color_hex = each.value.color_hex
  vm_role   = try(each.value.vm_role, false)
}

resource "netbox_cluster_type" "this" {
  for_each = toset(var.cluster_types)
  name     = each.value
}
