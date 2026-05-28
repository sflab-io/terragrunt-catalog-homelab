# netbox-k8s-cluster Specification

## Purpose
TBD - created by archiving change homelab-netbox-k8s-cluster. Update Purpose after archive.
## Requirements
### Requirement: Cluster-Verwaltung in NetBox
Das Modul `netbox-k8s-cluster` SHALL NetBox Virtualization-Cluster erstellen, aktualisieren und löschen. Es MUST mindestens `name` und `cluster_type_name` pro Cluster akzeptieren. Optionale Attribute sind `tenant_name`, `site_name`, `description` und `tags`.

#### Scenario: Cluster mit minimalem Input anlegen
- **WHEN** das Modul mit `name` und `cluster_type_name = "Kubernetes"` aufgerufen wird
- **THEN** wird ein NetBox-Cluster mit dem angegebenen Namen und Typ angelegt

#### Scenario: Cluster mit Tenant zuordnen
- **WHEN** `tenant_name = "platform-team"` angegeben wird
- **THEN** wird der Cluster dem Tenant "platform-team" in NetBox zugeordnet

#### Scenario: Cluster mit Site zuordnen
- **WHEN** `site_name` angegeben wird
- **THEN** wird der Cluster der entsprechenden Site zugeordnet

#### Scenario: Cluster ohne Tenant anlegen
- **WHEN** `tenant_name` nicht gesetzt wird (null)
- **THEN** wird der Cluster ohne Tenant-Zuordnung angelegt

### Requirement: Cluster-Type als Data Source nachschlagen
Das Modul SHALL den Cluster-Type per `data "netbox_cluster_type"` nachschlagen und MUST NOT selbst einen Cluster-Type anlegen.

#### Scenario: Vorhandener Cluster-Type wird verwendet
- **WHEN** der angegebene `cluster_type_name` in NetBox existiert
- **THEN** wird der Cluster mit der ID des gefundenen Typs angelegt

#### Scenario: Nicht vorhandener Cluster-Type
- **WHEN** der angegebene `cluster_type_name` in NetBox nicht existiert
- **THEN** schlägt das Apply mit einem verständlichen Provider-Fehler fehl

### Requirement: Modul-Output für Downstream-Nutzung
Das Modul SHALL die IDs und Namen der angelegten Cluster als Output bereitstellen, damit Downstream-Module (z. B. `netbox-virtual-machine`) darauf zugreifen können.

#### Scenario: Cluster-IDs als Output verfügbar
- **WHEN** das Modul erfolgreich angewendet wird
- **THEN** sind `cluster_ids` (map von name → id) und `cluster_names` (list) als Outputs verfügbar

### Requirement: Mehrere Cluster in einem Apply
Das Modul SHALL eine Liste von Clustern (`clusters`) akzeptieren und alle in einem einzigen OpenTofu-Apply-Vorgang verwalten.

#### Scenario: Zwei Cluster gleichzeitig anlegen
- **WHEN** `clusters` zwei Einträge enthält
- **THEN** werden beide Cluster in NetBox angelegt

### Requirement: Terragrunt-Unit parametrisierung via values
Die Unit `netbox-k8s-cluster` SHALL das Modul via Git-URL referenzieren und alle Cluster-Parameter über das `values.*`-Muster entgegennehmen.

#### Scenario: Unit-Deployment mit Stack-Values
- **WHEN** die Unit in einem Stack mit `values.clusters` konfiguriert wird
- **THEN** werden die Cluster korrekt an das Modul übergeben

### Requirement: Stack für einfaches Cluster-Deployment
Der Stack `homelab-netbox-k8s-cluster` SHALL die Unit `netbox-k8s-cluster` komponieren und in einem Live-Repository unter einem konfigurierbaren Pfad einsetzbar sein.

#### Scenario: Stack in staging-Umgebung einsetzen
- **WHEN** der Stack mit `values.clusters` in `staging/proxmox-mgm-cluster/terragrunt.stack.hcl` konfiguriert wird
- **THEN** werden die Kubernetes-Cluster in NetBox für die Staging-Umgebung angelegt

#### Scenario: VMs einem angelegten Cluster zuordnen
- **WHEN** ein Cluster via diesen Stack angelegt wurde
- **THEN** kann die bestehende `netbox-virtual-machine`-Unit VMs diesem Cluster über den Cluster-Namen zuordnen (via `data.netbox_cluster`)
