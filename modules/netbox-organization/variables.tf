# Sites and regions variables for NetBox organization module
variable "regions" {
  description = "A list of NetBox regions to create, where each region is an object with attributes (e.g., name, description)."
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}

variable "sites" {
  description = "A list of NetBox sites to create, where each site is an object with attributes (e.g., name, facility, latitude, longitude, timezone)."
  type = list(object({
    name        = string
    facility    = string
    latitude    = string
    longitude   = string
    timezone    = string
    region_name = optional(string)
  }))
  default = []
}

# Tenant and contact variables for NetBox organization module
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

variable "contact_groups" {
  description = "A list of contact groups to create in NetBox, where each contact group is an object with attributes (e.g., name)."
  type = list(object({
    name = string
  }))
  default = []
}

variable "contact_roles" {
  description = "A list of contact roles to create in NetBox, where each contact role is an object with attributes (e.g., name)."
  type = list(object({
    name = string
  }))
  default = []
}

variable "contacts" {
  description = "A list of contacts to create in NetBox, where each contact is an object with attributes (e.g., name, email, phone, group_name, role_name)."
  type = list(object({
    name       = string
    email      = string
    phone      = string
    group_name = optional(string)
    role_name  = optional(string)
  }))
  default = []
}
