data "netbox_cluster_type" "this" {
  for_each = toset([for c in var.clusters : c.cluster_type_name])
  name     = each.value
}

data "netbox_tenant" "this" {
  for_each = toset([for c in var.clusters : c.tenant_name if c.tenant_name != null])
  name     = each.value
}

data "netbox_site" "this" {
  for_each = toset([for c in var.clusters : c.site_name if c.site_name != null])
  name     = each.value
}

resource "netbox_cluster" "this" {
  for_each        = { for c in var.clusters : c.name => c }
  name            = each.value.name
  cluster_type_id = data.netbox_cluster_type.this[each.value.cluster_type_name].id
  tenant_id       = each.value.tenant_name != null ? data.netbox_tenant.this[each.value.tenant_name].id : null
  site_id         = each.value.site_name != null ? data.netbox_site.this[each.value.site_name].id : null
  description     = try(each.value.description, null)
  tags            = try(each.value.tags, [])
}
