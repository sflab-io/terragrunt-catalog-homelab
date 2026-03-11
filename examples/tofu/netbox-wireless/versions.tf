terraform {
  required_providers {
    # Pinned to ~> 2.0 (SDKv2) to avoid a plan-time validation bug in v3.0.
    # See modules/netbox-wireless/versions.tf for details.
    restapi = {
      source  = "Mastercard/restapi"
      version = "~> 2.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.1.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "restapi" {
  uri                  = "http://netbox-staging.home.sflab.io"
  write_returns_object = true

  headers = {
    Authorization = "Token ${var.netbox_token}"
    Content-Type  = "application/json"
  }
}

provider "netbox" {
  server_url         = "http://netbox-staging.home.sflab.io"
  skip_version_check = true
}
