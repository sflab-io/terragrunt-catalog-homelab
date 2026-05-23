package tofu_test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testModuleNaming(t *testing.T) {
	appName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/naming",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"app": appName,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	nameDev := terraform.Output(t, terraformOptions, "name_dev")
	nameProd := terraform.Output(t, terraformOptions, "name_prod")

	assert.Equal(t, fmt.Sprintf("%s-dev", appName), nameDev)
	assert.Equal(t, appName, nameProd)
}
