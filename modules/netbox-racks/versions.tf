terraform {
  required_providers {
    # Pinned to ~> 2.0 (SDKv2) to avoid a plan-time validation bug in v3.0.
    # See modules/netbox-wireless/versions.tf for full explanation.
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
