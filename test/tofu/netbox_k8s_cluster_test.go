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

func testModuleNetboxK8sCluster(t *testing.T) {
	clusterName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/netbox-k8s-cluster",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"cluster_name":     clusterName,
			"netbox_api_token": os.Getenv("NETBOX_API_TOKEN_PRODUCTION"),
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	clusterNames := terraform.OutputList(t, terraformOptions, "cluster_names")

	assert.Contains(t, clusterNames, clusterName)
}
