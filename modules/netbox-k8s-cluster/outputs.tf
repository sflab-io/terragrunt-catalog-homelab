output "cluster_ids" {
  description = "Map of cluster name to NetBox cluster ID."
  value       = { for name, cluster in netbox_cluster.this : name => cluster.id }
}

output "cluster_names" {
  description = "List of created NetBox cluster names."
  value       = [for name, cluster in netbox_cluster.this : cluster.name]
}
