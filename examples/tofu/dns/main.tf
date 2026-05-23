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

provider "dns" {
  update {
    server        = var.dns_server
    port          = 53
    key_name      = "ddnskey."
    key_algorithm = "hmac-sha256"
    key_secret    = var.dns_key_secret
  }
}

variable "dns_key_secret" {
  description = "TSIG key secret for DNS updates."
  type        = string
  sensitive   = true
}

variable "dns_server" {
  description = "DNS server address."
  type        = string
  default     = "192.168.1.13"
}

variable "app" {
  description = "Application name."
  type        = string
}

variable "env" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "zone" {
  description = "DNS zone (without trailing dot)."
  type        = string
  default     = "home.sflab.io"
}

variable "address" {
  description = "IP address for the DNS record."
  type        = string
  default     = "192.168.1.200"
}

module "dns" {
  source = "../../../modules/dns"

  env       = var.env
  app       = var.app
  zone      = var.zone
  addresses = [var.address]
  record_types = {
    normal   = true
    wildcard = true
  }
}

output "fqdn" {
  value = module.dns.fqdn
}

output "fqdn_wildcard" {
  value = module.dns.fqdn_wildcard
}

output "addresses" {
  value = module.dns.addresses
}
