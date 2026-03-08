# Variables for NetBox Virtual Machine module
variable "virtual_machines" {
  description = "A list of virtual machines to create in NetBox, where each virtual machine is an object with attributes (e.g., name, cluster_name, status)."
  type = list(object({
    name         = string
    cluster_name = string
    description  = optional(string)
    tags         = optional(list(string), [])
    role_name    = string
    tenant_name  = string
    vcpus        = optional(number)
    memory_mb    = optional(number)
    disk_size_mb = optional(number)
    interfaces = list(object({
      name     = string
      address  = string
      status   = string
      dns_name = string
    }))
  }))
  default = []
}
