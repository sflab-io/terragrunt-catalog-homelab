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
    name = "GeeekPi"
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
    name       = "Customer A"
    group_name = "customers"
  },
  {
    name       = "Customer B"
    group_name = "customers"
  },
  {
    name       = "Platform Team"
    group_name = "internal"
  }
]

contact_groups = [
  {
    name = "Platform Team Contacts"
  },
  {
    name = "Customer Contacts"
  }
]

# contact_roles = [
#   {
#     name = "Primary Contact"
#   },
#   {
#     name = "Secondary Contact"
#   }
# ]

contacts = [
  {
    name       = "John Doe"
    email      = "john.doe@example.com"
    phone      = "123-123123"
    group_name = "Platform Team Contacts"
    # role_name  = "Primary Contact"
  },
  {
    name       = "Jane Smith"
    email      = "jane.smith@example.com"
    phone      = "456-456456"
    group_name = "Customer Contacts"
    # role_name  = "Secondary Contact"
  }
]

# virtualization
cluster_types = ["Kubernetes", "Proxmox"]

clusters = [
  {
    name         = "k8s-cluster-mgm"
    cluster_type = "Kubernetes"
  },
  {
    name         = "proxmox-cluster-01"
    cluster_type = "Proxmox"
    # cluster_group_id = 1
  }
]

virtual_machines = [
  {
    name         = "k8s-control-plane-1"
    cluster_name = "k8s-cluster-mgm"
    tenant_name  = "Platform Team"
  },
  {
    name         = "k8s-worker-1"
    cluster_name = "k8s-cluster-mgm"
    tenant_name  = "Platform Team"
  }
]
