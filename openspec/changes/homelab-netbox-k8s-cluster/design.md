## Context

Das Homelab betreibt Kubernetes-Cluster auf Proxmox-VMs. NetBox dient als DCIM/IPAM-Quelle der Wahrheit. Bisher werden VMs via `netbox-virtual-machine`-Modul erfasst, aber Kubernetes-Cluster existieren in NetBox nicht als Virtualization-Cluster-Objekte. Der bestehende `netbox-virtual-machine`-Code setzt bereits voraus, dass ein Cluster in NetBox existiert (`data "netbox_cluster"`), legt diesen aber nicht an.

Ziel ist es, einen dedizierten Mechanismus bereitzustellen, um NetBox-Cluster (Typ: Kubernetes) als eigenständige Infrastruktur-Ressource zu verwalten, bevor VMs einem Cluster zugeordnet werden.

## Goals / Non-Goals

**Goals:**
- Neues OpenTofu-Modul `modules/netbox-k8s-cluster` für NetBox Virtualization-Cluster vom Typ "Kubernetes"
- Terragrunt-Unit `units/netbox-k8s-cluster` als parametrisierter Wrapper
- Terragrunt-Stack `stacks/homelab-netbox-k8s-cluster` für die Nutzung in Live-Repos
- Vollständige Beispiele (tofu, unit, stack) und Terratest-Tests

**Non-Goals:**
- Keine Verwaltung der VMs selbst (das bleibt `netbox-virtual-machine`)
- Kein automatisches Verknüpfen des Clusters mit VMs (die VM-Unit referenziert den Cluster-Namen bereits via `data.netbox_cluster`)
- Keine Proxmox-Ressourcen (reine NetBox-Verwaltung)
- Kein Management von Kubernetes-Cluster-Nodes auf Betriebssystem-Ebene

## Decisions

### Entscheidung 1: Cluster Type als Variable vs. fest verdrahtet

**Entscheidung**: Der Cluster-Typ wird als Variable `cluster_type_name` mit Default `"Kubernetes"` bereitgestellt.

**Rationale**: Obwohl der Use-Case Kubernetes ist, ermöglicht eine Variable Wiederverwendung für andere Cluster-Typen (z. B. "VMware", "OpenShift") ohne Modul-Duplikation. Das Modul schlägt den Typ per `data "netbox_cluster_type"` nach — der Typ muss in NetBox bereits existieren (wird nicht angelegt). Der Cluster-Typ "Kubernetes" ist in NetBox standardmäßig vorhanden.

**Alternativ betrachtet**: Cluster-Type als Resource anlegen — abgelehnt, weil Cluster-Types global sind und idempotentes Anlegen zu Race-Conditions bei parallelen Deployments führt.

### Entscheidung 2: Tenant-Zuordnung als Pflicht vs. optional

**Entscheidung**: `tenant_name` ist eine optionale Variable (default: `null`). Wenn leer, wird kein Tenant zugeordnet.

**Rationale**: Entspricht dem Muster im bestehenden `netbox-virtual-machine`-Modul, das `site_name` optional hält. Ermöglicht Nutzung ohne Tenant-Pflichtfeld.

### Entscheidung 3: Modul-Scope (ein Cluster vs. Liste)

**Entscheidung**: Das Modul verwaltet eine Liste von Clustern (`clusters` Variable), analog zu `virtual_machines` im bestehenden Modul.

**Rationale**: Konsistenz mit dem bestehenden Muster. Ermöglicht es, mehrere Cluster in einem Terraform-Apply-Vorgang zu verwalten.

### Entscheidung 4: Unit-Struktur (direkt vs. mit `netbox-k8s-cluster-direct`)

**Entscheidung**: Nur eine Unit `units/netbox-k8s-cluster` analog zu `units/netbox-virtual-machine`. Keine separate `-direct`-Variante für den initialen Scope.

**Rationale**: Die Komplexität einer zweiten Unit ist nicht gerechtfertigt — der Stack ist bereits eigenständig ohne Dependencies auf andere Units.

## Risks / Trade-offs

- **[Risk] Cluster-Type existiert nicht in NetBox** → Der `data "netbox_cluster_type"` Data Source schlägt fehl, wenn der Typ nicht angelegt ist. Mitigation: Dokumentation und ggf. Fehler-Output im Modul.
- **[Risk] Stack-Tests erfordern committete Änderungen auf GitHub** → Bekannte Einschränkung im Projekt. Mitigation: Unit- und Modul-Tests laufen lokal; Stack-Tests werden nach Push ausgeführt.
- **[Trade-off] Cluster-Type nicht anlegen** → Vereinfacht das Modul, erfordert aber manuelle Vorbereitung in NetBox. Akzeptabel, da "Kubernetes" in NetBox standardmäßig vorhanden ist.
