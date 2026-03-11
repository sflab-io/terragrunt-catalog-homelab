wireless_lans = [
  {
    ssid        = "HomeNet"
    description = "Primary home network"
    status      = "active"
    auth_type   = "wpa-personal"
    auth_cipher = "aes"
    auth_psk    = "super-secret-passphrase"
    vlan_name   = "Default"
    tenant_name = "Platform Team"
    # tags        = ["homelab"]
  }
  # ,
  # {
  #   ssid   = "HomeNet-Guest"
  #   status = "active"
  # },
]
