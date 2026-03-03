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
    "Router" = {
        color_hex = "00ffff"
        vm_role   = false
    }
    "Server" = {
        color_hex = "ffff00"
        vm_role   = true
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
