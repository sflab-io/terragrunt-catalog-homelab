locals {
  # Variables for NetBox virtual machine module
  virtual_machines = values.virtual_machines
}

unit "netbox_virtual_machine" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-virtual-machine?ref=${values.version}"

  path = "netbox_virtual_machine"

  values = {
    version = values.version

    virtualization_path = "../netbox_virtualization"

    virtual_machines = local.virtual_machines
  }
}
