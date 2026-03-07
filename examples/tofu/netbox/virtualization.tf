variable "cluster_types" {
  description = "A list of cluster types to create in NetBox."
  type        = list(string)
  default     = []
}

variable "clusters" {
  description = "A list of clusters to create in NetBox, where each cluster is an object with attributes (e.g., name, cluster_type)."
  type = list(object({
    name             = string
    cluster_type     = string
    cluster_group_id = optional(number)
  }))
  default = []
}

variable "virtual_machines" {
  description = "A list of virtual machines to create in NetBox, where each virtual machine is an object with attributes (e.g., name, cluster_name)."
  type = list(object({
    name         = string
    cluster_name = string
    tenant_name  = optional(string)
  }))
  default = []
}

# -- Resources --

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

resource "netbox_virtual_machine" "base_vm" {
  for_each   = { for vm in var.virtual_machines : vm.name => vm }
  name       = each.value.name
  cluster_id = lookup(netbox_cluster.this, each.value.cluster_name, null).id
  tenant_id  = try(lookup(netbox_tenant.this, each.value.tenant_name, null).id, null)
}
