resource "netbox_tag" "this" {
  for_each = toset(var.tags)
  name     = each.value
}
