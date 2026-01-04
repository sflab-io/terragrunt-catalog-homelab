data "homelab_naming" "this" {
  env = var.env
  app = var.app
}

data "local_file" "ssh_public_key" {
  filename = var.ssh_public_key_path
}

resource "proxmox_virtual_environment_container" "this" {
  node_name    = "pve1"
  unprivileged = true

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  initialization {
    hostname = data.homelab_naming.this.name

    dynamic "dns" {
      for_each = var.network_config.type == "static" && length(var.network_config.dns_servers) > 0 ? [1] : []
      content {
        domain  = var.network_config.domain
        servers = var.network_config.dns_servers
      }
    }

    ip_config {
      ipv4 {
        address = var.network_config.type == "dhcp" ? "dhcp" : "${var.network_config.ip_address}/${var.network_config.cidr}"
        gateway = var.network_config.type == "static" ? var.network_config.gateway : null
      }
    }

    user_account {
      keys = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  network_interface {
    name   = "veth0"
    bridge = var.network_bridge
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
    type             = "ubuntu"
  }
}

resource "proxmox_virtual_environment_pool_membership" "this" {
  count = var.pool_id != "" ? 1 : 0

  pool_id = var.pool_id
  vm_id   = proxmox_virtual_environment_container.this.vm_id
}
