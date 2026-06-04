# CLAUDE.md

## Architecture

Three-layer structure: **modules** (raw OpenTofu) → **units** (Terragrunt wrappers) → **stacks** (multi-unit compositions).

- `modules/`: Building blocks, no Terragrunt logic
- `units/`: Use Git URLs as `source` (external consumption); parameterized via `values.*` pattern
- `stacks/`: Compose units via `terragrunt.stack.hcl`; generate into `.terragrunt-stack/`
- `examples/terragrunt/`: Use relative paths to modules/units for local testing
- `examples/tofu/`: Direct module usage without Terragrunt

## Non-Obvious Constraints

**Units & Stacks:**
- Each `unit` block in a stack **must** have a `path` attribute
- Use double-slash `//` in relative module paths: `../../../.././/modules/proxmox-lxc`
- Dependencies between units use path values (`compute_path`, `dns_path`, `cluster_path`), not `dependency` blocks
- Pool management is separate — pass `pool_id` as a value; deploy pools via `examples/terragrunt/stacks/homelab-proxmox-pool`
- SSH key paths in stacks must be absolute: `"${get_repo_root()}/keys/admin_id_ecdsa.pub"` (relative paths break in `.terragrunt-cache`)
- `catalog_version` in `examples/terragrunt/environment.hcl` must be `"main"` on main branch (enforced by pre-commit hook)
- `homelab-wildcard-dns` stack deploys wildcard DNS records independently (no compute dependency); use `dns-wildcard` unit

**DNS:**
- Zone input is WITHOUT trailing dot — the module appends it automatically
- Execution order (automatic via dependencies): compute → dns → netbox
- `record_types = { normal = true, wildcard = false }` — both can be true simultaneously

**Naming:** All resources follow `<app>-<env>` for non-prod, `<app>` for prod (via naming module).

**NetBox units:**
- `netbox-virtual-machine`: depends on `dns_path` for IP retrieval; optional `cluster_path` for K8s cluster assignment
- `netbox-virtual-machine-direct`: accepts `virtual_machines` list directly, no DNS dependency
- All NetBox units include both `root` and `provider_netbox` config blocks

**Provider:**
- Use **bpg/proxmox** (>= 0.69.0), **not** telmate/proxmox
- Pool assignment: use `proxmox_pool_membership` resource — not the deprecated `pool_id` attribute

## Environment Variables

Auto-loaded on directory entry — do not manually set unless overriding:
- **sops `.creds.env.yaml`**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `PROXMOX_VE_API_TOKEN`, `PROXMOX_VE_ENDPOINT`, `PROXMOX_VE_INSECURE`, `TF_VAR_dns_key_secret`
- **fnox (Vault KV)**: `NETBOX_API_TOKEN`, `TSIG_KEY_NAME`, `TSIG_KEY_SECRET`

Vault token at `~/.vault-token` is read on directory entry. If missing: create `~/.vault-approle` with `role_id`/`secret_id` and run `mise run vault:login`.

## Testing

Two test runners exist with different purposes:

### Terratest (Go-based, automated)

Stack tests fetch units from the remote repo — **all changes must be committed and pushed before running stack tests.**

```bash
mise run test:terratest                              # All tests
mise run test:terratest -d tofu                     # Module tests only
mise run test:terratest -d terragrunt/units         # Unit tests only
mise run test:terratest -d terragrunt/stacks        # Stack tests only (requires pushed commits)
mise run test:terratest -n TestAll/ModuleDns        # Specific test by name
mise run test:terratest -f                          # Bypass Go test cache
```

Tests are organized as subtests under `TestAll`. Available subtests:
- **tofu/**: `ModuleNaming`, `ModuleDns`, `ModuleProxmoxPool`, `ModuleProxmoxLxc`, `ModuleProxmoxVm`, `ModuleNetboxVirtualMachine`, `ModuleNetboxTags`, `ModuleNetboxK8sCluster`
- **terragrunt/units/**: `UnitNaming`, `UnitDns`, `UnitDnsWildcard`, `UnitProxmoxPool`, `UnitProxmoxVm`, `UnitProxmoxLxc`, `UnitNetboxTags`, `UnitNetboxVirtualMachine`, `UnitNetboxK8sCluster`
- **terragrunt/stacks/**: `StackHomelabProxmoxLxc`, `StackHomelabProxmoxVm`, `StackHomelabNetboxVirtualMachine`, `StackHomelabNetboxK8sCluster`

### Integration Tests (shell-based, sequential deploy+destroy)

```bash
mise run test:all -a    # All integration tests
mise run test:all -t    # Tofu module tests only
mise run test:all -u    # Terragrunt unit tests only
mise run test:all -s    # Terragrunt stack tests only
```

Runs actual apply+destroy cycles in order. A flag is required — running without flags exits with an error.

## Mise Tasks Reference

```bash
# Terragrunt Units (examples/terragrunt/units/)
mise run terragrunt:unit:apply <unit>     # Apply a unit (interactive picker if no arg)
mise run terragrunt:unit:plan <unit>
mise run terragrunt:unit:destroy <unit>

# Terragrunt Stacks (examples/terragrunt/stacks/)
mise run terragrunt:stack:apply <stack>   # Apply a stack (-y for non-interactive)
mise run terragrunt:stack:plan <stack>
mise run terragrunt:stack:destroy <stack>
mise run terragrunt:stack:generate <stack>
mise run terragrunt:cleanup               # Remove .terragrunt-stack/.terragrunt-cache/.terraform

# Tofu Modules (examples/tofu/)
mise run tofu:init <module>
mise run tofu:plan <module>               # Outputs .tfplan and .tfplan.tfgraph
mise run tofu:apply <module>
mise run tofu:destroy <module>
mise run tofu:output <module>

# Infrastructure Setup
mise run vault:login                      # Create Vault token from AppRole credentials
mise run minio:setup                      # Setup MinIO service account and bucket
mise run minio:list                       # List MinIO buckets
mise run proxmox:setup                    # Setup Proxmox user/role for Terraform
```

All tasks support `-d`/`--dry-run` to print the command without executing it. Unit/stack tasks show an interactive picker (via `gum`) when no target is provided.

## Important Reminders

- Do not add any 'DNS TSIG Key Setup' instructions to CLAUDE.md because the setup is done in a separate Ansible project
