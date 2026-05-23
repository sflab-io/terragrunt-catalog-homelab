package terragrunt_units_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testUnitProxmoxLxc(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/proxmox-lxc",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	ipv4 := terraform.Output(t, terraformOptions, "ipv4")

	assert.Equal(t, "192.168.1.99", ipv4)
}
