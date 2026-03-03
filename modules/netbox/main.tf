resource "netbox_region" "this" {
  name        = var.region_name
  description = var.region_description
}

resource "netbox_site" "this" {
  name      = var.site_name
  facility  = var.site_facility
  latitude  = var.site_latitude
  longitude = var.site_longitude
  status    = "active"
  timezone  = var.timezone
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

resource "netbox_cluster" "this" {
  for_each         = { for cluster in var.clusters : cluster.name => cluster }
  cluster_type_id  = lookup(netbox_cluster_type.this, each.value.cluster_type, null).id
  name             = each.value.name
  cluster_group_id = try(each.value.cluster_group_id, null)
}
