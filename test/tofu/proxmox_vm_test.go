package tofu_test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testModuleProxmoxVm(t *testing.T) {
	appName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
	env := "dev"

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/proxmox-vm",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"app": appName,
			"env": env,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ipv4 := terraform.Output(t, terraformOptions, "ipv4")
	vmName := terraform.Output(t, terraformOptions, "vm_name")

	assert.NotEmpty(t, ipv4, "VM should have received a DHCP IP address")
	assert.Equal(t, fmt.Sprintf("%s-%s", appName, env), vmName)
}
