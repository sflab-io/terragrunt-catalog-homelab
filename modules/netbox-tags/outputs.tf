output "tag_names" {
  description = "Names of the created NetBox tags."
  value       = [for t in netbox_tag.this : t.name]
}
