variable "clusters" {
  description = "A list of Kubernetes clusters to create in NetBox."
  type = list(object({
    name              = string
    cluster_type_name = optional(string, "Kubernetes")
    tenant_name       = optional(string)
    site_name         = optional(string)
    description       = optional(string)
    tags              = optional(list(string), [])
  }))
  default = []
}
