output "wireless_lans" {
  description = "Map of created wireless LANs keyed by SSID, with their NetBox IDs and API URLs."
  value = {
    for ssid, wlan in restapi_object.this : ssid => {
      id  = wlan.id
      url = "${var.netbox_url}/api/wireless/wireless-lans/${wlan.id}/"
    }
  }
}
