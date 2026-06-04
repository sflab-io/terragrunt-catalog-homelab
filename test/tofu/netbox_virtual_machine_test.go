package tofu_test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testModuleNetboxVirtualMachine(t *testing.T) {
	vmName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/netbox-virtual-machine",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"vm_name":          vmName,
			"netbox_api_token": os.Getenv("NETBOX_API_TOKEN"),
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	vmNames := terraform.OutputList(t, terraformOptions, "vm_names")

	assert.Contains(t, vmNames, vmName)
}
