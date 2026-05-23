package terragrunt_stacks_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func testStackHomelabNetboxVirtualMachine(t *testing.T) {
	options := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/stacks/homelab-netbox-virtual-machine",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, options, "stack", "run", "destroy")

	terraform.RunTerraformCommand(t, options, "stack", "run", "apply")

	vmNamesJSON, err := terraform.RunTerraformCommandAndGetStdoutE(t, options, "stack", "output", "-json", "homelab_netbox_virtual_machine.netbox_virtual_machine.vm_names")
	require.NoError(t, err)

	assert.Contains(t, vmNamesJSON, "example-netbox-vm-staging", "vm_names sollte 'example-netbox-vm-staging' enthalten, war: %s", vmNamesJSON)
}
