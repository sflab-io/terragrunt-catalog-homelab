package tofu_test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testModuleProxmoxLxc(t *testing.T) {
	appName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
	env := "dev"

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/proxmox-lxc",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"app": appName,
			"env": env,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ipv4 := terraform.Output(t, terraformOptions, "ipv4")

	assert.NotEmpty(t, ipv4, "LXC container should have received a DHCP IP address")
}
