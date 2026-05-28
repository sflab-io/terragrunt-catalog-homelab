# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `homelab-netbox-k8s-cluster` stack: registers Kubernetes clusters in NetBox automatically
- `homelab-proxmox-vm` stack: automatic Kubernetes cluster assignment in NetBox when deploying VMs

### Fixed

- Cluster type naming in NetBox configuration is now consistently lowercase

## [0.18.0] - 2026-05-25

### Added

- `netbox-virtual-machine-direct` unit for registering VMs in NetBox without a compute or DNS dependency — useful for standalone NetBox stacks
- `netbox-tags` unit for idempotent tag management in NetBox (creates tags only if they do not already exist)
- Terratest integration test suite covering all modules, Terragrunt units, and Terragrunt stacks

### Fixed

- `dns_path` is now optional in the `netbox-virtual-machine` unit, allowing the unit to be used without a DNS dependency

## [0.17.0] - 2026-04-05

### Added

- `netbox-tags` module for idempotent tag creation in NetBox — tags are created independently of VM resources to prevent `409 Conflict` errors when multiple stacks share the same tag

### Changed

- Homelab provider source and version updated across all modules

## [0.16.0] - 2026-04-04

### Changed

- Pool membership resource renamed from `proxmox_virtual_environment_pool_membership` to `proxmox_pool_membership` in both the `proxmox-lxc` and `proxmox-vm` modules; a `moved` block ensures seamless state migration without resource recreation

## [0.15.0] - 2026-04-03

### Added

- `modules/netbox-tags` and `units/netbox-tags` for creating NetBox tags in a dedicated state, avoiding `409 Conflict` errors when multiple stacks reference the same tag
- `extra_tags` field in the `netbox-virtual-machine` module to reference pre-existing tags by name via data source, as opposed to `tags` which are owned and managed by the same state
- `homelab-proxmox-vm` stack now supports passing `extra_tags` through to the NetBox virtual machine unit

## [0.14.0] - 2026-04-01

No user-facing changes — this version tag was created on the same commit as `v0.13.0`.

## [0.13.0] - 2026-04-01

### Changed

- Tags handling in the Proxmox VM Terragrunt configuration refactored to use a local variable for improved consistency and readability

## [0.12.0] - 2026-03-31

### Fixed

- VM and LXC container naming convention corrected to consistently use `<app>-<env>` format across all resources

## [0.11.0] - 2026-03-31

### Added

- Dynamic tag support for LXC containers in the `homelab-proxmox-lxc` stack; containers are automatically tagged with `<app>-<env>` in NetBox
- NetBox virtual machine resources now create and assign unique tags per VM (e.g., `<app>-<env>`)

### Changed

- `virtual_machines` definition moved to the `locals` block in `homelab-proxmox-lxc` stack for consistency and to allow overriding via `values.virtual_machines`

## [0.10.0] - 2026-03-29

### Added

- Configurable `cpu_type` parameter for the `proxmox-vm` module, unit, and stack — allows specifying CPU types such as `host` or `qemu64` instead of the previous hardcoded default

[Unreleased]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.18.0...HEAD
[0.18.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.17.0...v0.18.0
[0.17.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.16.0...v0.17.0
[0.16.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/sflab-io/terragrunt-catalog-homelab/releases/tag/v0.10.0
