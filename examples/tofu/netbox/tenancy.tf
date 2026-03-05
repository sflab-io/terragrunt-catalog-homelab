variable "tenant_groups" {
  description = "A list of tenant groups to create in NetBox, where each tenant group is an object with attributes (e.g., name)."
  type = list(object({
    name = string
  }))
  default = []
}

variable "tenants" {
  description = "A list of tenants to create in NetBox, where each tenant is an object with attributes (e.g., name, group_name)."
  type = list(object({
    name       = string
    group_name = optional(string)
  }))
  default = []
}

# -- Resources --

resource "netbox_tenant_group" "this" {
  for_each = { for tenant_group in var.tenant_groups : tenant_group.name => tenant_group }
  name     = each.value.name
}

resource "netbox_tenant" "this" {
  for_each = { for tenant in var.tenants : tenant.name => tenant }
  name     = each.value.name
  group_id = try(netbox_tenant_group.this[each.value.group_name].id, null)
}
