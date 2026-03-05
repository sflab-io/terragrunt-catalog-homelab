# dcim
region_name        = "Home Region"
region_description = "This is the home region for my lab environment."

site_name      = "Home Site"
site_facility  = "Home data center"
site_latitude  = "48.7844"
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

# virtualization
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

# tenancy
tenant_groups = [
  {
    name = "customers"
  },
  {
    name = "internal"
  }
]

tenants = [
  {
    name     = "Customer A"
    group_id = 1
  },
  {
    name     = "Customer B"
    group_id = 1
  },
  {
    name     = "Platform Team"
    group_id = 2
  }
]
