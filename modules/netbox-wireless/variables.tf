variable "netbox_url" {
  description = "Base URL of the NetBox instance (e.g. http://netbox.home.sflab.io). Used to construct resource URLs in outputs."
  type        = string
}

variable "wireless_lans" {
  description = "List of wireless LANs to create in NetBox."
  type = list(object({
    ssid        = string
    description = optional(string, "")
    status      = optional(string, "active")
    auth_type   = optional(string)
    auth_cipher = optional(string)
    auth_psk    = optional(string)
    vlan_name   = optional(string)
    group_id    = optional(number)
    tenant_name = optional(string)
    tags        = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for wlan in var.wireless_lans :
      contains(["open", "wep", "wpa-personal", "wpa-enterprise"], coalesce(wlan.auth_type, "open"))
    ])
    error_message = "auth_type must be one of: open, wep, wpa-personal, wpa-enterprise."
  }

  validation {
    condition = alltrue([
      for wlan in var.wireless_lans :
      contains(["auto", "tkip", "aes"], coalesce(wlan.auth_cipher, "auto"))
    ])
    error_message = "auth_cipher must be one of: auto, tkip, aes."
  }
}
