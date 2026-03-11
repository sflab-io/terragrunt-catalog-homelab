variable "netbox_token" {
  description = "NetBox API token."
  type        = string
  sensitive   = true
}

variable "wireless_lans" {
  description = "A list of wireless LANs to create in NetBox, where each wireless LAN is an object with attributes (e.g., ssid, vlan_id, description)."
  type = list(object({
    ssid        = string
    description = optional(string)
    status      = optional(string, "active")
    auth_type   = optional(string, "wpa-personal")
    auth_cipher = optional(string, "aes")
    auth_psk    = optional(string)
    vlan_name   = optional(string)
    tenant_name = optional(string)
    tags        = optional(list(string), [])
  }))
  default = []
}

module "netbox_wireless" {
  source = "../../../modules/netbox-wireless"

  netbox_url = "http://netbox-staging.home.sflab.io"

  wireless_lans = var.wireless_lans
}

output "wireless_lans" {
  value = module.netbox_wireless.wireless_lans
}
