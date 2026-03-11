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
      wlan.vlan_name != null ? { vlan = tonumber(data.netbox_vlan.this[wlan.vlan_name].id) } : {},
      wlan.group_id != null ? { group = wlan.group_id } : {},
      wlan.tenant_name != null ? { tenant = tonumber(data.netbox_tenant.this[wlan.tenant_name].id) } : {},
    )
  }
}

data "netbox_vlan" "this" {
  for_each = toset([for wlan in var.wireless_lans : wlan.vlan_name if wlan.vlan_name != null])
  name     = each.value
}

data "netbox_tenant" "this" {
  for_each = toset([for wlan in var.wireless_lans : wlan.tenant_name if wlan.tenant_name != null])
  name     = each.value
}

resource "restapi_object" "this" {
  for_each = local.wireless_lans

  path         = "/api/wireless/wireless-lans/"
  data         = jsonencode(each.value)
  id_attribute = "id"
}
