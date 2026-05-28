terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.1.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "netbox" {
  server_url         = "http://netbox.home.sflab.io"
  skip_version_check = true
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster to create in NetBox."
  type        = string
}

module "netbox_k8s_cluster" {
  source = "../../../modules/netbox-k8s-cluster"

  clusters = [
    {
      name              = var.cluster_name
      cluster_type_name = "kubernetes"
    }
  ]
}

output "cluster_names" {
  description = "Names of the created NetBox clusters."
  value       = module.netbox_k8s_cluster.cluster_names
}

output "cluster_ids" {
  description = "Map of cluster name to NetBox cluster ID."
  value       = module.netbox_k8s_cluster.cluster_ids
}
