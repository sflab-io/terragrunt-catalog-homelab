package terragrunt_units_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testUnitNetboxVirtualMachine(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/netbox-virtual-machine",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	vmNames := terraform.OutputList(t, terraformOptions, "vm_names")

	assert.ElementsMatch(t, []string{"example-vm-a", "example-vm-b"}, vmNames)
}
