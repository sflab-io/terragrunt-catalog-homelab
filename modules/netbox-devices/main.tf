resource "netbox_device_role" "this" {
  for_each  = var.device_roles
  name      = each.key
  color_hex = each.value.color_hex
  vm_role   = try(each.value.vm_role, false)
}
