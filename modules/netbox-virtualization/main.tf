resource "netbox_cluster_type" "this" {
  for_each = { for cluster_type in var.cluster_types : cluster_type.name => cluster_type }
  name     = each.value.name
}

data "netbox_site" "this" {
  for_each = toset([for cluster in var.clusters : cluster.site_name])
  name     = each.value
}

data "netbox_tenant" "this" {
  for_each = toset([for cluster in var.clusters : cluster.tenant_name])
  name     = each.value
}

resource "netbox_cluster" "this" {
  for_each        = { for cluster in var.clusters : cluster.name => cluster }
  cluster_type_id = netbox_cluster_type.this[each.value.cluster_type_name].id
  name            = each.value.name
  site_id         = try(data.netbox_site.this[each.value.site_name].id, null)
  tenant_id       = try(data.netbox_tenant.this[each.value.tenant_name].id, null)
}
