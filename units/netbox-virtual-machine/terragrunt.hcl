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

locals {
  # Optional: path to a netbox-k8s-cluster unit for automatic cluster assignment.
  # When set, VMs are assigned to that cluster (overrides cluster_name in virtual_machines).
  cluster_path    = try(values.cluster_path, null)
  use_cluster_dep = local.cluster_path != null
}

terraform {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//modules/netbox-virtual-machine?ref=${values.version}"
}

dependency "dns" {
  config_path = values.dns_path

  mock_outputs = {
    addresses = ["192.168.1.99"]
    fqdn      = "example-vm.home.sflab.io"
  }
}

# When cluster_path is set, this dependency creates ordering (cluster before VMs)
# and provides the cluster name. Falls back to dns_path with skip_outputs when unused.
dependency "cluster" {
  config_path  = local.use_cluster_dep ? local.cluster_path : values.dns_path
  skip_outputs = !local.use_cluster_dep

  mock_outputs = {
    cluster_names = ["mock-k8s-cluster"]
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
      cluster_name = local.use_cluster_dep ? try(tolist(dependency.cluster.outputs.cluster_names)[0], vm.cluster_name) : vm.cluster_name
    })
  ]
}
