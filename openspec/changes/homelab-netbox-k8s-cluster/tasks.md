## 1. OpenTofu-Modul `modules/netbox-k8s-cluster`

- [x] 1.1 Verzeichnis `modules/netbox-k8s-cluster/` anlegen mit `versions.tf` (NetBox-Provider `e-breuninger/netbox ~> 5.1.0`, OpenTofu `>= 1.9.0`)
- [x] 1.2 `variables.tf` mit `clusters`-Variable erstellen: Liste von Objekten mit `name`, `cluster_type_name` (default: `"Kubernetes"`), `tenant_name` (optional, null), `site_name` (optional, null), `description` (optional), `tags` (optional, list)
- [x] 1.3 `main.tf` implementieren: `data "netbox_cluster_type"`, `data "netbox_tenant"` (optional), `data "netbox_site"` (optional), `resource "netbox_cluster"` mit `for_each` über die Cluster-Liste
- [x] 1.4 `outputs.tf` implementieren: `cluster_ids` (map von name → id) und `cluster_names` (list)

## 2. OpenTofu-Beispiel `examples/tofu/netbox-k8s-cluster`

- [x] 2.1 Verzeichnis `examples/tofu/netbox-k8s-cluster/` anlegen mit `main.tf`: Provider-Block (NetBox), Variable `cluster_name`, Modul-Aufruf mit relativem Pfad `../../../modules/netbox-k8s-cluster`
- [x] 2.2 Outputs in `examples/tofu/netbox-k8s-cluster/main.tf` ergänzen: `cluster_names`, `cluster_ids`

## 3. Terragrunt-Unit `units/netbox-k8s-cluster`

- [x] 3.1 Verzeichnis `units/netbox-k8s-cluster/` anlegen mit `terragrunt.hcl`: `include "root"`, `include "provider_netbox"`, `generate "provider"`-Block für NetBox-Provider, `terraform.source` via Git-URL `git::git@github.com:sflab-io/terragrunt-catalog-homelab.git//modules/netbox-k8s-cluster?ref=${values.version}`
- [x] 3.2 `inputs`-Block in der Unit hinzufügen: `clusters = values.clusters`

## 4. Terragrunt-Unit-Beispiel `examples/terragrunt/units/netbox-k8s-cluster`

- [x] 4.1 Verzeichnis `examples/terragrunt/units/netbox-k8s-cluster/` anlegen mit `terragrunt.hcl`: `include "root"`, NetBox-Provider-Generierung, `terraform.source` als relativer Pfad `../../../.././/modules/netbox-k8s-cluster`
- [x] 4.2 `inputs`-Block mit konkretem Beispiel-Cluster (name: `"proxmox-mgm-cluster-staging"`, cluster_type_name: `"Kubernetes"`, tenant_name: `"Platform Team"`)

## 5. Terragrunt-Stack `stacks/homelab-netbox-k8s-cluster`

- [x] 5.1 Verzeichnis `stacks/homelab-netbox-k8s-cluster/` anlegen mit `terragrunt.stack.hcl`: `locals`-Block für `clusters` aus `values.clusters`, `unit "netbox_k8s_cluster"`-Block mit Git-URL-Referenz, `path = "netbox-k8s-cluster"` (Pflicht), `values`-Übergabe

## 6. Terragrunt-Stack-Beispiel `examples/terragrunt/stacks/homelab-netbox-k8s-cluster`

- [x] 6.1 Verzeichnis `examples/terragrunt/stacks/homelab-netbox-k8s-cluster/` anlegen mit `terragrunt.stack.hcl`: `locals`-Block liest `environment.hcl`, `stack "homelab_netbox_k8s_cluster"`-Block referenziert `stacks/homelab-netbox-k8s-cluster` via Git-URL mit `catalog_version`, konkrete `values.clusters`-Konfiguration für Staging-Umgebung

## 7. Test: OpenTofu-Modul (`test/tofu/`)

- [x] 7.1 Testfunktion `testModuleNetboxK8sCluster` in `test/tofu/netbox_k8s_cluster_test.go` erstellen: zufälliger Cluster-Name, `terraform.InitAndApply`, Output `cluster_names` validieren, `defer terraform.Destroy`
- [x] 7.2 `TestAll`-Funktion in `test/tofu/main_test.go` um `t.Run("ModuleNetboxK8sCluster", testModuleNetboxK8sCluster)` erweitern

## 8. Test: Terragrunt-Unit (`test/terragrunt/units/`)

- [x] 8.1 Testfunktion `testUnitNetboxK8sCluster` in `test/terragrunt/units/netbox_k8s_cluster_test.go` erstellen: Terragrunt-Apply auf `examples/terragrunt/units/netbox-k8s-cluster`, Output `cluster_names` validieren
- [x] 8.2 `TestAll`-Funktion in `test/terragrunt/units/main_test.go` um `t.Run("UnitNetboxK8sCluster", testUnitNetboxK8sCluster)` erweitern

## 9. Test: Terragrunt-Stack (`test/terragrunt/stacks/`)

- [x] 9.1 Testfunktion `testStackHomelabNetboxK8sCluster` in `test/terragrunt/stacks/homelab_netbox_k8s_cluster_test.go` erstellen: Stack-Apply auf `examples/terragrunt/stacks/homelab-netbox-k8s-cluster`, Stack-Output validieren, `defer` Stack-Destroy
- [x] 9.2 `TestAll`-Funktion in `test/terragrunt/stacks/main_test.go` um `t.Run("StackHomelabNetboxK8sCluster", testStackHomelabNetboxK8sCluster)` erweitern
