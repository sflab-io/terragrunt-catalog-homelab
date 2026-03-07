# Devices variables for NetBox devices module
variable "device_roles" {
  description = "A map of device roles to create in NetBox, where the key is the role name and the value is an object with role attributes (e.g., color_hex)."
  type = map(object({
    color_hex = string
    vm_role   = optional(bool, false)
  }))
  default = {}
}
