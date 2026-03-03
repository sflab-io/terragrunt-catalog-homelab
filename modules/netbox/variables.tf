variable "region_name" {
  description = "The name of the NetBox region."
  type        = string
}

variable "region_description" {
  description = "The description of the NetBox region."
  type        = string
}

variable "site_name" {
  description = "The name of the NetBox site."
  type        = string
}

variable "site_facility" {
  description = "The facility of the NetBox site."
  type        = string
}

variable "site_latitude" {
  description = "The latitude of the NetBox site."
  type        = string
}

variable "site_longitude" {
  description = "The longitude of the NetBox site."
  type        = string
}

variable "timezone" {
  description = "The timezone to use for the site."
  type        = string
}

variable "device_roles" {
  description = "A map of device roles to create in NetBox, where the key is the role name and the value is an object with role attributes (e.g., color_hex)."
  type = map(object({
    color_hex = string
    vm_role   = optional(bool, false)
  }))
  default = {}
}

variable "cluster_types" {
  description = "A list of cluster types to create in NetBox."
  type        = list(string)
  default     = []
}
