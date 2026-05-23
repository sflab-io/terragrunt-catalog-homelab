output "vm_names" {
  description = "Names of the created NetBox virtual machines."
  value       = [for name, vm in netbox_virtual_machine.this : vm.name]
}
