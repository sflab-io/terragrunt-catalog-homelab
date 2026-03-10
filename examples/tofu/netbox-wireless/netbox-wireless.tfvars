wireless_lans = [
  {
    ssid        = "HomeNet"
    description = "Primary home network"
    status      = "active"
    auth_type   = "wpa-personal"
    auth_cipher = "aes"
    auth_psk    = "super-secret-passphrase"
    # tags        = ["homelab"]
  },
  {
    ssid   = "HomeNet-Guest"
    status = "active"
  },
]
