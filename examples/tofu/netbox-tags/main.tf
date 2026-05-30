terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.1.0"
    }
  }
  required_version = ">= 1.9.0"
}

variable "netbox_api_token" {
  description = "NetBox API token."
  type        = string
  sensitive   = true
}

provider "netbox" {
  server_url         = "http://netbox.home.sflab.io"
  skip_version_check = true
  api_token          = var.netbox_api_token
}

variable "tags" {
  description = "List of tags to create in NetBox."
  type        = list(string)
  default     = []
}

module "netbox_tags" {
  source = "../../../modules/netbox-tags"

  tags = var.tags
}

output "tag_names" {
  description = "Names of the created NetBox tags."
  value       = module.netbox_tags.tag_names
}
