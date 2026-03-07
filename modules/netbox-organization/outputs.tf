output "site_ids" {
  value = { for name, site in netbox_site.this : name => site.id }
}
