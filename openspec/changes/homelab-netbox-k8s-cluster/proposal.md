## Why

Das Homelab verwendet Kubernetes-Cluster auf Proxmox-VMs, die bisher nicht in NetBox als Virtualization-Cluster erfasst werden. Ohne diese Erfassung können VMs nicht einem Kubernetes-Cluster zugeordnet werden, was die DCIM/IPAM-Datenbasis unvollständig macht und die Nachvollziehbarkeit der Infrastruktur einschränkt.

## What Changes

- **Neues OpenTofu-Modul** `modules/netbox-k8s-cluster`: Verwaltet NetBox Virtualization-Cluster mit Typ "Kubernetes", inklusive optionaler Tenant- und Site-Zuordnung
- **Neue Terragrunt-Unit** `units/netbox-k8s-cluster`: Terragrunt-Wrapper um das Modul mit `values.*`-Parameterisierung, referenziert das Modul via Git-URL
- **Neuer Terragrunt-Stack** `stacks/homelab-netbox-k8s-cluster`: Komponiert die neue Unit; kann in Live-Repositories eingesetzt werden (z. B. `staging/proxmox-mgm-cluster/terragrunt.stack.hcl`)
- **Beispiel für OpenTofu-Direktnutzung** `examples/tofu/netbox-k8s-cluster/`: Direktes Modul-Beispiel ohne Terragrunt
- **Beispiel für Unit-Nutzung** `examples/terragrunt/units/netbox-k8s-cluster/`: Lokales Testbeispiel mit relativem Modulpfad
- **Beispiel für Stack-Nutzung** `examples/terragrunt/stacks/homelab-netbox-k8s-cluster/`: Lokales Testbeispiel, das den Catalog-Stack referenziert
- **Tests**: Terratest-Tests für das Modul (`test/tofu/`), die Unit (`test/terragrunt/units/`) und den Stack (`test/terragrunt/stacks/`)

Die bestehende `netbox-virtual-machine`-Unit kann nach dem Anlegen des Clusters die VMs dem Cluster zuordnen – kein Breaking Change an bestehenden Ressourcen.

## Capabilities

### New Capabilities

- `netbox-k8s-cluster`: Verwaltet NetBox Virtualization-Cluster vom Typ "Kubernetes" mit Tenant-Zuordnung, optionaler Site-Zuordnung und Tags; ermöglicht es anschließend, VMs über das bestehende `netbox-virtual-machine`-Modul diesem Cluster zuzuordnen

### Modified Capabilities

<!-- keine bestehenden Spec-Anforderungen ändern sich -->

## Impact

- **Neue Dateien**: `modules/netbox-k8s-cluster/`, `units/netbox-k8s-cluster/`, `stacks/homelab-netbox-k8s-cluster/`, `examples/tofu/netbox-k8s-cluster/`, `examples/terragrunt/units/netbox-k8s-cluster/`, `examples/terragrunt/stacks/homelab-netbox-k8s-cluster/`, `test/tofu/netbox_k8s_cluster_test.go`
- **Provider**: NetBox-Provider `e-breuninger/netbox ~> 5.1.0` (bereits in Verwendung)
- **Stack-Tests**: Erfordern committete und gepushte Änderungen auf GitHub (bestehende Einschränkung im Projekt)
- **Keine Breaking Changes**: Bestehende Module, Units und Stacks bleiben unverändert
