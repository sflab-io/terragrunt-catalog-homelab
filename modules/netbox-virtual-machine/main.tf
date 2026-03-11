// Assumes vmw-cluster-01 exists in Netbox
data "netbox_cluster" "this" {
  for_each = toset([for vm in var.virtual_machines : vm.cluster_name])
  name     = each.value
}

data "netbox_device_role" "this" {
  for_each = toset([for vm in var.virtual_machines : vm.role_name])
  name     = each.value
}

data "netbox_tenant" "this" {
  for_each = toset([for vm in var.virtual_machines : vm.tenant_name])
  name     = each.value
}

resource "netbox_interface" "this" {
  for_each           = { for vm in var.virtual_machines : vm.name => vm }
  name               = each.value.interfaces[0].name
  virtual_machine_id = netbox_virtual_machine.this[each.value.name].id
}

resource "netbox_ip_address" "this" {
  for_each     = { for vm in var.virtual_machines : vm.name => vm }
  ip_address   = each.value.interfaces[0].address
  dns_name     = try(each.value.interfaces[0].dns_name, null)
  status       = try(each.value.interfaces[0].status, null)
  interface_id = netbox_interface.this[each.value.name].id
  object_type  = "virtualization.vminterface"
}

resource "netbox_virtual_machine" "this" {
  for_each     = { for vm in var.virtual_machines : vm.name => vm }
  name         = each.value.name
  description  = try(each.value.description, null)
  cluster_id   = data.netbox_cluster.this[each.value.cluster_name].id
  role_id      = data.netbox_device_role.this[each.value.role_name].id
  tenant_id    = data.netbox_tenant.this[each.value.tenant_name].id
  vcpus        = try(each.value.vcpus, null)
  memory_mb    = try(each.value.memory_mb, null)
  disk_size_mb = try(each.value.disk_size_mb, null)
}

resource "netbox_primary_ip" "this" {
  for_each           = { for vm in var.virtual_machines : vm.name => vm }
  ip_address_id      = netbox_ip_address.this[each.value.name].id
  virtual_machine_id = netbox_virtual_machine.this[each.value.name].id
}
