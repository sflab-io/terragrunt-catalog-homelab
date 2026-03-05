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

variable "manufacturers" {
  description = "A list of manufacturers to create in NetBox, where each manufacturer is an object with attributes (e.g., name)."
  type = list(object({
    name = string
  }))
  default = []
}

# -- Resources --

resource "netbox_region" "this" {
  name        = var.region_name
  description = var.region_description
}

resource "netbox_site" "this" {
  name      = var.site_name
  facility  = var.site_facility
  latitude  = var.site_latitude
  longitude = var.site_longitude
  status    = "active"
  timezone  = var.timezone
  region_id = netbox_region.this.id
}

resource "netbox_device_role" "this" {
  for_each  = var.device_roles
  name      = each.key
  color_hex = each.value.color_hex
  vm_role   = try(each.value.vm_role, false)
}

# resource "netbox_manufacturer" "this" {
#   for_each = { for manufacturer in var.manufacturers : manufacturer.name => manufacturer }
#   name     = each.value.name
# }
