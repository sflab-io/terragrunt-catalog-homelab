# Variables for NetBox Virtualization module
variable "cluster_types" {
  description = "A list of cluster types to create in NetBox, where each cluster type is an object with attributes (e.g., name, description)."
  type = list(object({
    name = string
  }))
  default = []
}

variable "netbox_clusters" {
  description = "A list of clusters to create in NetBox, where each cluster is an object with attributes (e.g., name, cluster_type_name, cluster_group_name)."
  type = list(object({
    name              = string
    cluster_type_name = string
    site_name         = optional(string)
    tenant_name       = optional(string)
  }))
  default = []
}
