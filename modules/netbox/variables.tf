variable "netbox_region_name" {
  description = "The name of the NetBox region."
  type        = string
  default     = "Home Region"
}

variable "netbox_region_description" {
  description = "The description of the NetBox region."
  type        = string
  default     = "This is the home region for my lab environment."
}

variable "netbox_site_name" {
  description = "The name of the NetBox site."
  type        = string
  default     = "Home Site"
}

variable "netbox_site_facility" {
  description = "The facility of the NetBox site."
  type        = string
  default     = "Data center"
}

variable "netbox_site_latitude" {
  description = "The latitude of the NetBox site."
  type        = string
  default     = "48.7844"
}

variable "netbox_site_longitude" {
  description = "The longitude of the NetBox site."
  type        = string
  default     = "9.2078"
}

variable "netbox_timezone" {
  description = "The timezone to use for the site."
  type        = string
  default     = "Europe/Berlin"
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
