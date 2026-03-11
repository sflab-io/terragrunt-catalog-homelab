# Terragrunt Catalog Homelab

A Terragrunt infrastructure catalog for managing Proxmox homelab environments. This project provides reusable infrastructure components (modules, units, and stacks) for deploying LXC containers, virtual machines, DNS records, and NetBox DCIM/IPAM resources using OpenTofu/Terraform and Terragrunt.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Usage](#usage)
  - [Environment Setup](#environment-setup)
  - [Working with Units](#working-with-units)
  - [Working with Stacks](#working-with-stacks)
  - [Working with VMs](#working-with-vms)
  - [Working with NetBox](#working-with-netbox)
- [Available Modules](#available-modules)
- [Available Commands](#available-commands)
- [Configuration](#configuration)
- [Development](#development)
- [License](#license)

## Overview

This repository provides a three-layer architecture for managing infrastructure as code:

1. **Modules**: Raw OpenTofu/Terraform modules for specific resources
2. **Units**: Terragrunt wrappers around modules with standardized configuration
3. **Stacks**: Compositions of multiple units that work together

### Features

- LXC container deployment on Proxmox
- Virtual machine deployment via template cloning
- Automated DNS record management (including wildcard records)
- NetBox DCIM/IPAM management (organization, racks, devices, IPAM, virtualization, virtual machines)
- Standardized resource naming conventions
- S3-compatible state management with MinIO
- Pre-commit hooks for code quality
- Comprehensive test suite

## Architecture

### Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│                        Stacks                           │
│  (Complete deployments: VM/Container + DNS, NetBox)     │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────────┐
│                        Units                            │
│  (Terragrunt wrappers with standardized inputs)         │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────────┐
│                       Modules                           │
│  (Raw OpenTofu/Terraform resources)                     │
└─────────────────────────────────────────────────────────┘
```

### Available Infrastructure Components

**Proxmox & DNS:**
- **proxmox-lxc**: Deploy Ubuntu 24.04 LXC containers
- **proxmox-vm**: Deploy virtual machines via template cloning
- **proxmox-pool**: Create and manage Proxmox resource pools
- **dns**: Manage DNS A records (normal and wildcard)
- **naming**: Standardized resource naming (format: `{env}-{app}`)

**NetBox DCIM/IPAM:**
- **netbox-organization**: Manage regions, sites, tenants, and contacts
- **netbox-racks**: Manage rack types and physical racks
- **netbox-devices**: Manage device roles, manufacturers, device types, and devices
- **netbox-ipam**: Manage VLANs and IP prefixes
- **netbox-virtualization**: Manage cluster types and clusters
- **netbox-virtual-machine**: Manage virtual machine records with interfaces and IPs
- **netbox-wireless**: Manage wireless LANs in NetBox

## Prerequisites

### Required Tools

All tools are managed via [mise](https://mise.jdx.dev/):

- Go 1.24.2
- OpenTofu 1.11.5
- Terragrunt 0.99.4
- MinIO Client (mc) - latest

### Required Services

- **Proxmox VE**: Version 8.x (configured with API access)
- **MinIO**: S3-compatible storage for Terragrunt state
- **BIND9 DNS Server**: For dynamic DNS updates (optional)
- **NetBox**: DCIM/IPAM platform (optional, for NetBox modules)

### SSH Keys for VMs

When deploying VMs, you need SSH keys in the `keys/` directory:

- `admin_id_ecdsa.pub`: ECDSA public key for admin user SSH access

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/sflab-io/terragrunt-catalog-homelab.git
cd terragrunt-catalog-homelab
```

### 2. Install Tools

```bash
# mise will automatically install tools when you cd into the directory
cd .
# Or manually install
mise install
```

### 3. Configure Credentials

```bash
# Set MinIO credentials (for state backend)
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"

# Set Proxmox credentials
# Format: username@realm!tokenname=secret
export PROXMOX_VE_API_TOKEN="root@pam!tofu=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Set DNS TSIG key secret (if using DNS module)
export TF_VAR_dns_key_secret="your-tsig-key-secret"

# Set NetBox API token (if using NetBox modules)
export TF_VAR_netbox_token="your-netbox-api-token"
```

### 4. Deploy Your First Container

```bash
# Navigate to example unit
cd examples/terragrunt/units/proxmox-lxc

# Initialize Terragrunt
terragrunt init

# Review changes
terragrunt plan

# Apply changes
terragrunt apply
```

### 5. Deploy a Complete Stack

```bash
# Navigate to stack example
cd examples/terragrunt/stacks/homelab-proxmox-lxc

# Generate stack
terragrunt stack generate

# Review changes
terragrunt stack run plan

# Deploy stack
terragrunt stack run apply
```

## Project Structure

```
.
├── modules/              # Raw OpenTofu/Terraform modules
│   ├── dns/             # DNS A record management
│   ├── naming/          # Resource naming conventions
│   ├── netbox-devices/  # NetBox device management
│   ├── netbox-ipam/     # NetBox IPAM (VLANs/prefixes)
│   ├── netbox-organization/  # NetBox org hierarchy
│   ├── netbox-racks/    # NetBox rack management
│   ├── netbox-virtual-machine/  # NetBox VM records
│   ├── netbox-virtualization/   # NetBox cluster management
│   ├── netbox-wireless/ # NetBox wireless LAN management
│   ├── proxmox-lxc/     # LXC container deployment
│   ├── proxmox-pool/    # Proxmox resource pools
│   └── proxmox-vm/      # Virtual machine deployment
├── units/               # Terragrunt wrappers (production)
│   ├── dns/
│   ├── naming/
│   ├── netbox-devices/
│   ├── netbox-ipam/
│   ├── netbox-organization/
│   ├── netbox-racks/
│   ├── netbox-virtual-machine/
│   ├── netbox-virtualization/
│   ├── netbox-wireless/
│   ├── proxmox-lxc/
│   ├── proxmox-pool/
│   └── proxmox-vm/
├── stacks/              # Stack compositions (production)
│   ├── homelab-netbox-init/
│   ├── homelab-netbox-virtual-machine/
│   ├── homelab-proxmox-lxc/
│   └── homelab-proxmox-vm/
├── examples/            # Local testing examples
│   ├── terragrunt/     # Terragrunt examples
│   │   ├── environment.hcl      # Shared environment config
│   │   ├── root.hcl             # Root Terragrunt config
│   │   ├── backend-config.hcl   # MinIO backend config
│   │   ├── provider-proxmox-config.hcl
│   │   ├── provider-dns-config.hcl
│   │   ├── provider-netbox-config.hcl
│   │   ├── units/      # Individual unit examples
│   │   └── stacks/     # Stack examples
│   └── tofu/           # Direct OpenTofu examples
├── keys/                # SSH public keys for VMs
│   └── admin_id_ecdsa.pub
├── openspec/            # OpenSpec change management
└── mise.toml           # Tool version management
```

## Usage

### Environment Setup

#### Required Environment Variables

```bash
# MinIO Backend (required for all operations)
export AWS_ACCESS_KEY_ID="your-minio-access-key"
export AWS_SECRET_ACCESS_KEY="your-minio-secret-key"

# Proxmox Provider (required for Proxmox operations)
export PROXMOX_VE_API_TOKEN="root@pam!tofu=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# DNS TSIG Key (required only when using DNS module)
export TF_VAR_dns_key_secret="your-tsig-key-secret"

# NetBox API Token (required only when using NetBox modules)
export TF_VAR_netbox_token="your-netbox-api-token"
```

#### Optional: Edit Encrypted Secrets

```bash
# Edit SOPS-encrypted secrets file
mise run secrets:edit
```

### Working with Units

Units are individual infrastructure components that can be deployed independently.

#### Deploy an LXC Container

```bash
cd examples/terragrunt/units/proxmox-lxc

# Initialize
terragrunt init

# Plan
terragrunt plan

# Apply
terragrunt apply

# Destroy
terragrunt destroy
```

#### Deploy a Virtual Machine

```bash
cd examples/terragrunt/units/proxmox-vm

# Initialize
terragrunt init

# Plan
terragrunt plan

# Apply
terragrunt apply

# Destroy
terragrunt destroy
```

#### Interactive Unit Management

```bash
# Quick apply (with interactive menu)
mise run terragrunt:unit:apply

# Quick plan (with interactive menu)
mise run terragrunt:unit:plan

# Quick destroy (with interactive menu)
mise run terragrunt:unit:destroy
```

### Working with Stacks

Stacks combine multiple units into coordinated deployments.

#### Available Production Stacks (`stacks/`)

- **homelab-netbox-init**: NetBox initialization stack (organization → racks → devices → IPAM → virtualization)
- **homelab-netbox-virtual-machine**: NetBox virtual machine records stack
- **homelab-proxmox-lxc**: LXC container + DNS
- **homelab-proxmox-vm**: Virtual machine + DNS

#### Available Example Stacks (`examples/terragrunt/stacks/`)

- **homelab-proxmox-pool**: Proxmox resource pool only
- **homelab-proxmox-lxc**: LXC container + DNS (uses production stack via Git reference)
- **homelab-proxmox-vm**: Virtual machine + DNS (uses production stack via Git reference)
- **homelab-wildcard-dns**: Container with normal + wildcard DNS records
- **homelab-netbox-init**: NetBox DCIM/IPAM initialization stack (organization → racks → devices → IPAM → virtualization)
- **homelab-netbox-virtual-machine**: NetBox virtual machine records stack

#### Deploy a Stack

```bash
cd examples/terragrunt/stacks/homelab-proxmox-lxc

# Generate stack (creates .terragrunt-stack directory)
terragrunt stack generate

# Plan changes
terragrunt stack run plan

# Apply changes
terragrunt stack run apply

# Destroy resources
terragrunt stack run destroy
```

#### Interactive Stack Management

```bash
# Quick apply (with interactive menu)
mise run terragrunt:stack:apply

# Quick plan (with interactive menu)
mise run terragrunt:stack:plan

# Quick destroy (with interactive menu)
mise run terragrunt:stack:destroy

# Generate stack locally
mise run terragrunt:stack:generate
```

### Working with VMs

#### VM Configuration Options

Virtual machines support both DHCP (default) and static IP configuration:

**DHCP Configuration (Default)**

```hcl
unit "proxmox_vm" {
  values = {
    env = "dev"
    app = "web"
    # network_config defaults to DHCP
  }
}
```

**Static IP Configuration**

```hcl
unit "proxmox_vm" {
  values = {
    env = "dev"
    app = "web"
    network_config = {
      type        = "static"
      ip_address  = "192.168.1.100"
      cidr        = 24
      gateway     = "192.168.1.1"
      dns_servers = ["8.8.8.8", "8.8.4.4"]  # Optional
    }
  }
}
```

#### SSH Key Configuration

VMs require SSH keys for admin access. Place your public key in the `keys/` directory:

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ecdsa -b 521 -f keys/admin_id_ecdsa -C "admin@homelab"

# The public key (admin_id_ecdsa.pub) will be used by VMs
```

When deploying VM stacks, use absolute paths for SSH keys:

```hcl
locals {
  # Use get_repo_root() for absolute paths
  ssh_public_key_path = "${get_repo_root()}/keys/admin_id_ecdsa.pub"
}

unit "proxmox_vm" {
  values = {
    env                 = "dev"
    app                 = "web"
    ssh_public_key_path = local.ssh_public_key_path
  }
}
```

### DNS Records

The DNS module supports both normal and wildcard DNS records.

#### Record Types

- **Normal Record**: Creates `{env}-{app}.home.sflab.io`
  - Example: `dev-web.home.sflab.io`
- **Wildcard Record**: Creates `*.{env}-{app}.home.sflab.io`
  - Example: `*.dev-web.home.sflab.io`
  - Matches: `api.dev-web.home.sflab.io`, `anything.dev-web.home.sflab.io`, etc.

#### DNS Configuration Examples

**Normal Record Only (Default)**

```hcl
unit "dns" {
  values = {
    env          = "dev"
    app          = "web"
    zone         = "home.sflab.io."
    compute_path = "../proxmox-lxc"
  }
}
```

**Wildcard Record Only**

```hcl
unit "dns_wildcard" {
  values = {
    env          = "dev"
    app          = "web"
    zone         = "home.sflab.io."
    record_types = {
      normal   = false
      wildcard = true
    }
    compute_path = "../proxmox-lxc"
  }
}
```

**Both Normal and Wildcard Records**

```hcl
unit "dns_both" {
  values = {
    env          = "dev"
    app          = "web"
    zone         = "home.sflab.io."
    record_types = {
      normal   = true   # Creates dev-web.home.sflab.io
      wildcard = true   # Creates *.dev-web.home.sflab.io
    }
    compute_path = "../proxmox-lxc"
  }
}
```

#### Verify DNS Records

```bash
# Verify normal record
dig dev-web.home.sflab.io @192.168.1.13

# Verify wildcard record
dig api.dev-web.home.sflab.io @192.168.1.13
```

### Working with NetBox

NetBox units manage DCIM (Data Center Infrastructure Management) and IPAM (IP Address Management) resources.

#### NetBox Deployment Order

NetBox units have dependencies on each other and must be deployed in order:

```
netbox-organization → netbox-racks → netbox-devices → netbox-ipam → netbox-virtualization
```

The `homelab-netbox` example stack manages all these dependencies automatically.

#### Deploy the NetBox Initialization Stack

```bash
cd examples/terragrunt/stacks/homelab-netbox-init

# Set NetBox credentials
export TF_VAR_netbox_token="your-netbox-api-token"

# Generate and deploy
terragrunt stack generate
terragrunt stack run apply
```

#### Deploy the NetBox Virtual Machine Stack

```bash
cd examples/terragrunt/stacks/homelab-netbox-virtual-machine

# Set NetBox credentials
export TF_VAR_netbox_token="your-netbox-api-token"

# Generate and deploy
terragrunt stack generate
terragrunt stack run apply
```

#### Deploy Individual NetBox Units

```bash
# Example: deploy NetBox organization resources
cd examples/terragrunt/units/netbox-organization
terragrunt apply

# Example: deploy NetBox IPAM resources
cd examples/terragrunt/units/netbox-ipam
terragrunt apply
```

## Available Modules

### proxmox-lxc

Deploy Ubuntu 24.04 LXC containers on Proxmox.

**Required Inputs:**
- `env` (string): Environment name (e.g., "dev", "staging", "prod")
- `app` (string): Application name (e.g., "web", "db", "api")
- `ssh_public_key_path` (string): Path to the SSH public key file for SSH access

**Optional Inputs:**
- `memory` (number, default: 2048): Memory in MB
- `cores` (number, default: 2): CPU cores
- `pool_id` (string): Proxmox pool ID for resource organization
- `network_config` (object): Network configuration (DHCP or static)
- `network_bridge` (string, default: "vmbr0"): Network bridge to connect to

**Outputs:**
- `ipv4`: Container IP address

### proxmox-vm

Deploy virtual machines via template cloning.

**Required Inputs:**
- `env` (string): Environment name
- `app` (string): Application name
- `ssh_public_key_path` (string): Path to SSH public key

**Optional Inputs:**
- `memory` (number, default: 2048): Memory in MB
- `cores` (number, default: 2): CPU cores
- `disk_size` (number, default: 8): Disk size in GB
- `pool_id` (string): Proxmox pool ID
- `network_config` (object): Network configuration (DHCP or static)
- `username` (string, default: "admin"): SSH username

**Outputs:**
- `ipv4`: VM IP address
- `vm_id`: Proxmox VM ID
- `vm_name`: VM name

### proxmox-pool

Create Proxmox resource pools for organizing resources.

**Required Inputs:**
- `pool_id` (string): Pool identifier

**Optional Inputs:**
- `description` (string): Pool description

**Outputs:**
- `pool_id`: Pool identifier

### dns

Manage DNS A records on BIND9 servers via RFC 2136 dynamic updates.

**Required Inputs:**
- `env` (string): Environment name
- `app` (string): Application name
- `zone` (string): DNS zone (e.g., "home.sflab.io.")
- `addresses` (list(string)): List of IPv4 addresses

**Optional Inputs:**
- `ttl` (number, default: 300): DNS record TTL
- `record_types` (object): Control which DNS record types to create
  - `normal` (bool, default: true): Create `{env}-{app}` record
  - `wildcard` (bool, default: false): Create `*.{env}-{app}` record

**Outputs:**
- `fqdn`: Normal record FQDN (null if not created)
- `fqdn_wildcard`: Wildcard record FQDN (null if not created)
- `addresses`: IP addresses

### naming

Standardized resource naming using the homelab provider.

**Required Inputs:**
- `env` (string): Environment name
- `app` (string): Application name

**Outputs:**
- `generated_name`: Generated name (format: `{env}-{app}`)

### netbox-organization

Manages organizational hierarchy in NetBox (regions, sites, tenants, contacts).

**Required Inputs:**
- `regions` (list): List of region objects with name and description
- `sites` (list): List of site objects with facility, coordinates, timezone, and optional region
- `tenant_groups` (list): List of tenant group objects
- `tenants` (list): List of tenant objects with optional group reference
- `contact_groups` (list): List of contact group objects
- `contact_roles` (list): List of contact role objects
- `contacts` (list): List of contact objects with email, phone, group, and role

### netbox-racks

Manages physical rack infrastructure in NetBox.

**Required Inputs:**
- `manufacturers` (list): List of manufacturer objects
- `rack_types` (list): List of rack type objects with model, manufacturer, form factor, width, and height
- `racks` (list): List of rack objects with name, site, status, and rack type

### netbox-devices

Manages physical device definitions in NetBox.

**Required Inputs:**
- `device_roles` (map): Map of device roles with color hex and VM role flag
- `manufacturers` (list): List of manufacturer objects
- `device_types` (list): List of device type objects with model, manufacturer, and height
- `devices` (list): List of device objects with name, type, role, site, tenant, rack, and interfaces

### netbox-ipam

Manages IP address management resources in NetBox.

**Required Inputs:**
- `vlans` (list): List of VLAN objects with name, VID, and optional description
- `prefixes` (list): List of prefix objects with prefix, status, and optional VLAN reference

### netbox-virtualization

Manages virtual cluster infrastructure in NetBox.

**Required Inputs:**
- `cluster_types` (list): List of cluster type objects with name
- `clusters` (list): List of cluster objects with name, type, and optional site and tenant

### netbox-virtual-machine

Manages virtual machine records in NetBox.

**Required Inputs:**
- `virtual_machines` (list): List of VM objects with name, cluster, optional description/role/tenant/resources, and interfaces with IP addresses

### netbox-wireless

Manages wireless LAN records in NetBox.

**Required Inputs:**
- `netbox_url` (string): Base URL of the NetBox instance
- `wireless_lans` (list): List of wireless LAN objects with SSID, optional description, status, auth settings (type/cipher/psk), VLAN, group, and tenant

## Available Commands

### Mise Tasks

```bash
# MinIO Management
mise run minio:setup                # Setup MinIO bucket and service account
mise run minio:list                 # List MinIO buckets and contents

# Proxmox Management
mise run proxmox:setup              # Setup Proxmox resources (role and user)

# Network Management
mise run network:configure          # Configure network settings
mise run network:status             # Print network configuration

# Secrets Management
mise run secrets:edit               # Edit SOPS-encrypted secrets

# Terragrunt Management
mise run terragrunt:cleanup         # Clean up Terragrunt cache files

# Unit Operations (Interactive)
mise run terragrunt:unit:apply      # Quick apply for units
mise run terragrunt:unit:plan       # Quick plan for units
mise run terragrunt:unit:destroy    # Quick destroy for units

# Stack Operations (Interactive)
mise run terragrunt:stack:apply     # Quick apply for stacks
mise run terragrunt:stack:plan      # Quick plan for stacks
mise run terragrunt:stack:destroy   # Quick destroy for stacks
mise run terragrunt:stack:generate  # Generate stack locally

# Testing
mise run test:all -- -t             # Run only tofu module tests
mise run test:all -- -u             # Run only terragrunt unit tests
mise run test:all -- -s             # Run only terragrunt stack tests
mise run test:all -- -a             # Run all tests

# Direct OpenTofu Operations (Interactive or with target)
mise run tofu:init                  # Initialize OpenTofu modules
mise run tofu:init naming           # Initialize specific module
mise run tofu:plan                  # Plan OpenTofu changes
mise run tofu:apply                 # Apply OpenTofu changes
mise run tofu:output                # Show OpenTofu outputs
mise run tofu:destroy               # Destroy OpenTofu resources
```

### Terragrunt Operations

```bash
# Initialize
terragrunt init

# Plan changes
terragrunt plan

# Apply changes
terragrunt apply

# Destroy resources
terragrunt destroy

# Stack operations
terragrunt stack generate
terragrunt stack run plan
terragrunt stack run apply
terragrunt stack run destroy
```

### Development Commands

```bash
# Format all Terraform/OpenTofu files
tofu fmt -recursive

# Validate modules
cd modules/proxmox-lxc
tofu init
tofu validate

# Run pre-commit hooks manually
pre-commit run --all-files

# Clean up cache
mise run terragrunt:cleanup
```

## Configuration

### Environment Configuration

The shared environment configuration is in `examples/terragrunt/environment.hcl`. This file defines environment-wide variables used by all stack examples:

```hcl
locals {
  environment_name = "staging"
  pool_id          = "example-stack-pool"
  catalog_version  = "main"
  zone             = "home.sflab.io."
  admin_ssh_public_key_path = "${get_repo_root()}/keys/admin_id_ecdsa.pub"
}
```

### Backend Configuration

State is stored in MinIO (S3-compatible storage).

Configuration file: `examples/terragrunt/backend-config.hcl`

```hcl
endpoint = "http://minio.home.sflab.io:9000"
bucket   = "examples-terragrunt-tfstates"
```

### Proxmox Provider Configuration

Uses the bpg/proxmox provider (>= 0.69.0).

Configuration file: `examples/terragrunt/provider-proxmox-config.hcl`

```hcl
endpoint = "proxmox.home.sflab.io:8006"
```

### DNS Configuration

Centralized DNS server configuration.

Configuration file: `examples/terragrunt/provider-dns-config.hcl`

```hcl
server    = "192.168.1.13"
port      = 53
key_name  = "ddnskey."
algorithm = "hmac-sha256"
```

### NetBox Configuration

Centralized NetBox server configuration.

Configuration file: `examples/terragrunt/provider-netbox-config.hcl`

```hcl
netbox_server_url         = "http://netbox-staging.home.sflab.io"
netbox_skip_version_check = true
```

## Development

### Pre-commit Hooks

The repository uses pre-commit hooks to maintain code quality:

- **gitleaks**: Detects hardcoded secrets
- **fix end of files**: Ensures files end with newline
- **trim trailing whitespace**: Removes trailing whitespace
- **OpenTofu fmt**: Formats .tf files
- **OpenTofu validate**: Validates module syntax

Hooks are automatically installed when you enter the project directory.

To run manually:

```bash
pre-commit run --all-files
```

### Running Tests

```bash
# Run all tests
mise run test:all -- -a

# Run only module tests
mise run test:all -- -t

# Run only unit tests
mise run test:all -- -u

# Run only stack tests (requires committed changes)
mise run test:all -- -s
```

**Note**: Stack tests require all changes to be committed and pushed to GitHub because they fetch units from the remote repository.

### Adding New Modules

1. Create module directory in `modules/`
2. Define resources in `main.tf`
3. Declare variables in `variables.tf`
4. Export outputs in `outputs.tf`
5. Specify provider requirements in `versions.tf`
6. Add example in `examples/tofu/`

### Adding New Units

1. Create unit directory in `units/`
2. Create `terragrunt.hcl` with Git source URL
3. Add example in `examples/terragrunt/units/` with relative path
4. Document in CLAUDE.md

### Adding New Stacks

1. Create stack directory in `stacks/`
2. Create `terragrunt.stack.hcl` with unit references
3. Each unit must specify a `path` attribute
4. Add example in `examples/terragrunt/stacks/`
5. Document in CLAUDE.md

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or contributions, please open an issue on GitHub.

## Related Documentation

- [CLAUDE.md](./CLAUDE.md): Detailed technical documentation for AI assistants
- [AGENTS.md](./AGENTS.md): OpenSpec agent documentation
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [Proxmox VE API](https://pve.proxmox.com/pve-docs/api-viewer/)
