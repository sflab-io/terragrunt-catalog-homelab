terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.1.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "netbox" {
  server_url         = "http://netbox.home.sflab.io"
  skip_version_check = true
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

variable "timezone" {
  description = "The timezone to use for the site."
  type        = string
  default     = "Europe/Berlin"
}

variable "site_name" {
  description = "The name of the NetBox site."
  type        = string
  default     = "Home Site"
}

variable "site_facility" {
  description = "The facility of the NetBox site."
  type        = string
  default     = "Data center"
}

variable "site_latitude" {
  description = "The latitude of the NetBox site."
  type        = string
  default     = "48.7844"
}

variable "site_longitude" {
  description = "The longitude of the NetBox site."
  type        = string
  default     = "9.2078"
}

variable "region_name" {
  description = "The name of the NetBox region."
  type        = string
  default     = "Home Region"
}

variable "region_description" {
  description = "The description of the NetBox region."
  type        = string
  default     = "This is the home region for my lab environment."
}

resource "netbox_region" "this" {
  name        = var.region_name
  description = var.region_description
}

resource "netbox_site" "this" {
  name = var.site_name
  # asn       = 1337
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

resource "netbox_cluster_type" "this" {
  for_each = toset(var.cluster_types)
  name     = each.value
}
