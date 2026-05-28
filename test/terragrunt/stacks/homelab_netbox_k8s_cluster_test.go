package terragrunt_stacks_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func testStackHomelabNetboxK8sCluster(t *testing.T) {
	options := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/stacks/homelab-netbox-k8s-cluster",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, options, "stack", "run", "destroy")

	terraform.RunTerraformCommand(t, options, "stack", "run", "apply")

	clusterNamesJSON, err := terraform.RunTerraformCommandAndGetStdoutE(t, options, "stack", "output", "-json", "homelab_netbox_k8s_cluster.netbox_k8s_cluster.cluster_names")
	require.NoError(t, err)

	assert.Contains(t, clusterNamesJSON, "proxmox-mgm-cluster-staging", "cluster_names sollte 'proxmox-mgm-cluster-staging' enthalten, war: %s", clusterNamesJSON)
}
