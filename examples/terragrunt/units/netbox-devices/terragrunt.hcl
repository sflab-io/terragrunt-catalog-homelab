include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  netbox_config    = read_terragrunt_config(find_in_parent_folders("provider-netbox-config.hcl"))

  server_url         = local.netbox_config.locals.netbox_server_url
  skip_version_check = local.netbox_config.locals.netbox_skip_version_check
}

# Generate Netbox provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "netbox" {
  server_url         = "${local.server_url}"
  skip_version_check = ${local.skip_version_check}
}
EOF
}

terraform {
  source = "../../../.././/modules/netbox-devices"
}

inputs = {
  # Devices variables for NetBox devices module
  device_roles = {
    "Hypervisor" = {
      color_hex = "8a2be2"
      vm_role   = false
    }
    "Server" = {
      color_hex = "ffff00"
      vm_role   = true
    }
    "Router" = {
      color_hex = "00ffff"
      vm_role   = false
    }
    "Firewall" = {
      color_hex = "ff00ff"
      vm_role   = false
    }
    "Switch" = {
      color_hex = "00ff00"
      vm_role   = false
    }
    "AP" = {
      color_hex = "0000ff"
      vm_role   = false
    }
    "K8s Control Plane" = {
      color_hex = "ffa500"
      vm_role   = true
    }
    "K8s Worker" = {
      color_hex = "800000"
      vm_role   = true
    }
  }

  manufacturers = [
    {
      name = "Minisforum"
    },
    {
      name = "Netgear"
    },
    {
      name = "Protectli"
    }
  ]

  device_types = [
    {
      model             = "MS-01 Work Station"
      manufacturer_name = "Minisforum"
      u_height          = "1"
    },
    {
      model             = "FW4C-0-8-120"
      manufacturer_name = "Protectli"
      u_height          = "1"
    },
    {
      model             = "GS108Ev4"
      manufacturer_name = "Netgear"
      u_height          = "1"
    },
    {
      model             = "WAX210"
      manufacturer_name = "Netgear"
      u_height          = "1"
    }
  ]

  devices = [
    {
      name        = "SFLAB-HYPERVISOR-01"
      device_type = "MS-01 Work Station"
      role_name   = "Hypervisor"
      site_name   = "SFLAB Homelab Site"
      tenant_name = "Platform Team"
      rack_name   = "Rack 1"
      interfaces  = [
        {
          name = "eth0"
          type = "1000base-t"
          ip_addresses = [
            {
              address  = "192.168.1.12/32"
              dns_name = "netbox.home.sflab.io"
              status   = "active"
            }
          ]
        }
      ]
    },
    {
      name        = "SFLAB-FIREWALL-01"
      device_type = "FW4C-0-8-120"
      role_name   = "Firewall"
      site_name   = "SFLAB Homelab Site"
      tenant_name = "Platform Team"
      rack_name   = "Rack 1"
      interfaces  = [
        {
          name = "eth0"
          type = "1000base-t"
          ip_addresses = [
            {
              address  = "192.168.1.1/32"
              dns_name = "opnsense.home.sflab.io"
              status   = "active"
            }
          ]
        }
      ]
    },
    {
      name        = "SFLAB-SWITCH-01"
      device_type = "GS108Ev4"
      role_name   = "Router"
      site_name   = "SFLAB Homelab Site"
      tenant_name = "Platform Team"
      rack_name   = "Rack 1"
      interfaces  = [
        {
          name = "eth0"
          type = "1000base-t"
          ip_addresses = [
            {
              address  = "192.168.1.10/32"
              dns_name = "switch.home.sflab.io"
              status   = "active"
            }
          ]
        }
      ]
    },
    {
      name        = "SFLAB-AP-01"
      device_type = "WAX210"
      role_name   = "AP"
      site_name   = "SFLAB Homelab Site"
      tenant_name = "Platform Team"
      rack_name   = "Rack 1"
      interfaces  = [
        {
          name = "eth0"
          type = "1000base-t"
          ip_addresses = [
            {
              address  = "192.168.1.11/32"
              dns_name = "ap.home.sflab.io"
              status   = "active"
            }
          ]
        }
      ]
    }
  ]
}
