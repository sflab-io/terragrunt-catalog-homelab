locals {
  wireless_lans = {
    for wlan in var.wireless_lans : wlan.ssid => merge(
      {
        ssid        = wlan.ssid
        description = wlan.description
        status      = wlan.status
        tags        = [for tag in wlan.tags : { name = tag }]
      },
      wlan.auth_type != null ? { auth_type = wlan.auth_type } : {},
      wlan.auth_cipher != null ? { auth_cipher = wlan.auth_cipher } : {},
      wlan.auth_psk != null ? { auth_psk = wlan.auth_psk } : {},
      wlan.vlan_id != null ? { vlan = wlan.vlan_id } : {},
      wlan.group_id != null ? { group = wlan.group_id } : {},
    )
  }
}

resource "restapi_object" "this" {
  for_each = local.wireless_lans

  path         = "/api/wireless/wireless-lans/"
  data         = jsonencode(each.value)
  id_attribute = "id"
}
