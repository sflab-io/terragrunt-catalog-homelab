terraform {
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 3.0.0"
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
