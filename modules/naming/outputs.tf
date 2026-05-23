output "generated_name" {
  description = "Generated name: <app>-<env> for non-prod environments, <app> for prod"
  value       = data.homelab_naming.this.name
}
