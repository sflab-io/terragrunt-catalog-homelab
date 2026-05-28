locals {
  clusters = values.clusters
}

unit "netbox_k8s_cluster" {
  source = "git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//units/netbox-k8s-cluster?ref=${values.version}"

  path = "netbox-k8s-cluster"

  values = {
    version  = values.version
    clusters = local.clusters
  }
}
