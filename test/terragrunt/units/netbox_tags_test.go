package terragrunt_units_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestUnitNetboxTags(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/netbox-tags",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	tagNames := terraform.OutputList(t, terraformOptions, "tag_names")

	assert.ElementsMatch(t, []string{"example-lxc", "example-vm"}, tagNames)
}
