package terragrunt_units_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testUnitProxmoxVm(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/proxmox-vm",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	vmName := terraform.Output(t, terraformOptions, "vm_name")
	ipv4 := terraform.Output(t, terraformOptions, "ipv4")

	assert.Equal(t, "terragrunt-vm-dev", vmName)
	assert.Equal(t, "192.168.1.33", ipv4)
}
