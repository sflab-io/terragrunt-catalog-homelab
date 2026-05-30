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

variable "vm_name" {
  description = "Name of the virtual machine to create in NetBox."
  type        = string
}

variable "ip_address" {
  description = "IP address (with prefix) for the VM interface."
  type        = string
  default     = "10.99.99.10/24"
}

resource "netbox_cluster_type" "test" {
  name = "${var.vm_name}-cluster-type"
}

resource "netbox_cluster" "test" {
  name            = "${var.vm_name}-cluster"
  cluster_type_id = netbox_cluster_type.test.id
}

resource "netbox_device_role" "test" {
  name      = "${var.vm_name}-role"
  color_hex = "000000"
  vm_role   = true
}

resource "netbox_tenant" "test" {
  name = "${var.vm_name}-tenant"
}

module "netbox_virtual_machine" {
  source = "../../../modules/netbox-virtual-machine"

  depends_on = [
    netbox_cluster.test,
    netbox_device_role.test,
    netbox_tenant.test,
  ]

  virtual_machines = [
    {
      name         = var.vm_name
      cluster_name = netbox_cluster.test.name
      role_name    = netbox_device_role.test.name
      tenant_name  = netbox_tenant.test.name
      vcpus        = 2
      memory_mb    = 2048
      disk_size_mb = 8192
      interfaces = [
        {
          name     = "eth0"
          address  = var.ip_address
          dns_name = "${var.vm_name}.home.sflab.io"
          status   = "active"
        }
      ]
    }
  ]
}

output "vm_names" {
  description = "Names of the created NetBox virtual machines."
  value       = module.netbox_virtual_machine.vm_names
}
