locals {
  version = "feat/netbox"

  region_name = "sflab Homelab Region"
  region_description = "Region for sflab homelab infrastructure"

  site_name = "sflab Homelab Site"
  site_facility = "sflab Homelab Facility"
  site_latitude = "48.7844"
  site_longitude = "9.2078"
  timezone = "Europe/Berlin"

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
  }

  cluster_types = ["Kubernetes", "Proxmox"]

  clusters = [
    {
      name         = "k8s-cluster-01"
      cluster_type = "Kubernetes"
    },
    {
      name         = "proxmox-cluster-01"
      cluster_type = "Proxmox"
      # cluster_group_id = 1
    }
  ]
}

unit "netbox" {
  source = "../../../../units/netbox"

  path = "netbox"

  values = {
    version = local.version

    # Required values
    region_name = local.region_name
    region_description = local.region_description

    site_name = local.site_name
    site_facility = local.site_facility
    site_latitude = local.site_latitude
    site_longitude = local.site_longitude
    timezone = local.timezone

    device_roles = local.device_roles

    cluster_types = local.cluster_types
    clusters      = local.clusters

    # Optional values
    # ...
  }
}
