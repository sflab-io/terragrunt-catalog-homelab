terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.1.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "netbox" {
  server_url         = "http://netbox.home.sflab.io"
  skip_version_check = true
}
