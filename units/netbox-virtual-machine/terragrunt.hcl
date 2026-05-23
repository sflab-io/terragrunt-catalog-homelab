include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider_netbox" {
  path   = find_in_parent_folders("provider-netbox-config.hcl")
  expose = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "netbox" {
  server_url         = "${include.provider_netbox.locals.netbox_server_url}"
  skip_version_check = ${include.provider_netbox.locals.netbox_skip_version_check}
}
EOF
}

terraform {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//modules/netbox-virtual-machine?ref=${values.version}"
}

dependency "dns" {
  config_path = try(values.dns_path, "NONE")

  # Used when dns_path is not provided (standalone NetBox stacks) or dependency not yet applied
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "apply", "destroy", "output", "init"]

  mock_outputs = {
    addresses = ["192.168.1.99"]
    fqdn      = "example-vm.home.sflab.io"
  }
}

inputs = {
  virtual_machines = [
    for vm in values.virtual_machines : merge(vm, {
      interfaces = [
        {
          name     = "eth0"
          address  = "${dependency.dns.outputs.addresses[0]}/32"
          dns_name = dependency.dns.outputs.fqdn
          status   = "active"
        }
      ]
    })
  ]
}
