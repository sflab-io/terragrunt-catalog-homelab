package tofu_test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleProxmoxPool(t *testing.T) {
	t.Parallel()

	poolID := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/proxmox-pool",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"pool_id": poolID,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	name := terraform.Output(t, terraformOptions, "name")

	assert.Equal(t, poolID, name)
}
