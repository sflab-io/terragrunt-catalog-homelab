# Devices variables for NetBox devices module
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

variable "device_types" {
  description = "A list of device types to create in NetBox, where each device type is an object with attributes (e.g., model, part_number, manufacturer_name)."
  type = list(object({
    model             = string
    manufacturer_name = string
    u_height          = string
  }))
  default = []
}

variable "devices" {
  description = "A list of devices to create in NetBox, where each device is an object with attributes (e.g., name, device_type_model, role_name, site_name)."
  type = list(object({
    name        = string
    device_type = string
    role_name   = string
    site_name   = string
    tenant_name = string
    rack_name   = optional(string)
    interfaces = optional(list(object({
      name = string
      type = string
      ip_addresses = optional(list(object({
        address     = string
        dns_name    = optional(string)
        status      = optional(string)
        description = optional(string)
      })), [])
    })), [])
  }))
  default = []
}
