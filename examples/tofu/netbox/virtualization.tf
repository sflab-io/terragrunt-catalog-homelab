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
