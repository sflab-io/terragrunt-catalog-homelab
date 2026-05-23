package terragrunt_units_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testUnitNaming(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/naming",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	generatedName := terraform.Output(t, terraformOptions, "generated_name")

	assert.Equal(t, "web-staging", generatedName)
}
