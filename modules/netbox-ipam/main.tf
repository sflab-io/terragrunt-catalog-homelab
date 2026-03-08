resource "netbox_vlan" "this" {
  for_each    = { for vlan in var.vlans : vlan.vid => vlan }
  name        = each.value.name
  vid         = each.value.vid
  description = each.value.description
  tags        = each.value.tags
}

resource "netbox_prefix" "this" {
  for_each    = { for prefix in var.prefixes : prefix.prefix => prefix }
  prefix      = each.value.prefix
  status      = each.value.status
  description = each.value.description
  tags        = each.value.tags
  vlan_id     = netbox_vlan.this[each.value.vlan_id].id
}
