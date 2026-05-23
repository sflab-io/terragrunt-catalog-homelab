package terragrunt_units_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestUnitProxmoxPool(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/proxmox-pool",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	poolID := terraform.Output(t, terraformOptions, "pool_id")

	assert.Equal(t, "example-stack-pool", poolID)
}
