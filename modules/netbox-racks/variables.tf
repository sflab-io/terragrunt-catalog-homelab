# Racks variables for NetBox racks module
variable "manufacturers" {
  description = "A list of manufacturers to create in NetBox, where each manufacturer is an object with attributes (e.g., name)."
  type = list(object({
    name = string
  }))
  default = []
}

variable "rack_types" {
  description = "A list of NetBox rack types to create, where each rack type is an object with attributes (e.g., name, width, depth, height)."
  type = list(object({
    model         = string
    manufacturer  = string
    form_factor   = string
    width         = number
    u_height      = number
    starting_unit = number
  }))
  default = []
}

variable "racks" {
  description = "A list of NetBox racks to create, where each rack is an object with attributes (e.g., name, site_name, status)."
  type = list(object({
    name      = string
    site_name = string
    status    = string
  }))
  default = []
}
