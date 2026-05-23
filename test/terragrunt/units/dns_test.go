package terragrunt_units_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testUnitDnsWildcard(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/dns-wildcard",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	fqdnWildcard := terraform.Output(t, terraformOptions, "fqdn_wildcard")

	assert.Equal(t, "*.example-dev.home.sflab.io", fqdnWildcard)
}

func testUnitDns(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/units/dns",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, terraformOptions, "destroy", "-auto-approve")

	terraform.RunTerraformCommand(t, terraformOptions, "apply", "-auto-approve")

	fqdn := terraform.Output(t, terraformOptions, "fqdn")

	assert.Equal(t, "example-dev.home.sflab.io", fqdn)
}
