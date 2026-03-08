# IPAM variables for NetBox IPAM module
variable "vlans" {
  description = "A list of VLANs to create in NetBox, where each VLAN is an object with attributes (e.g., name, vid, site_name)."
  type = list(object({
    name        = string
    vid         = number
    description = optional(string)
    tags        = optional(list(string), [])
  }))
  default = []
}

variable "prefixes" {
  description = "A list of IP prefixes to create in NetBox, where each prefix is an object with attributes (e.g., prefix, status, description)."
  type = list(object({
    prefix      = string
    status      = string
    description = optional(string)
    tags        = optional(list(string), [])
    vlan_id     = optional(number)
  }))
  default = []
}
