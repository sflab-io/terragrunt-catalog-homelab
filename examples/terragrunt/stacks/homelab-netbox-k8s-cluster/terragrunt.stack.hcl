locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals

  clusters = [
    {
      name              = "proxmox-mgm-cluster-staging"
      cluster_type_name = "kubernetes"
      tenant_name       = "platform-team"
    }
  ]
}

stack "homelab_netbox_k8s_cluster" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//stacks/homelab-netbox-k8s-cluster?ref=${local.env.catalog_version}"

  path = "homelab-netbox-k8s-cluster"

  values = {
    version  = local.env.catalog_version
    clusters = local.clusters
  }
}
