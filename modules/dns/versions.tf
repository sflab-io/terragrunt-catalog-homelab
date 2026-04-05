terraform {
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.4.0"
    }
    homelab = {
      source  = "registry.opentofu.org/sflab-io/homelab"
      version = ">= 0.5.0"
    }
  }
  required_version = ">= 1.9.0"
}
