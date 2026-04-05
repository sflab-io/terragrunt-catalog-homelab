terraform {
  required_providers {
    proxmox = {
      source  = "registry.terraform.io/bpg/proxmox"
      version = ">= 0.69.0"
    }
    homelab = {
      source  = "registry.opentofu.org/sflab-io/homelab"
      version = ">= 0.5.0"
    }
  }
  required_version = ">= 1.9.0"
}
