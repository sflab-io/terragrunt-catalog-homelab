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

func testModuleNetboxTags(t *testing.T) {
	suffix := strings.ToLower(random.UniqueId())
	tags := []string{
		fmt.Sprintf("test-tag-a-%s", suffix),
		fmt.Sprintf("test-tag-b-%s", suffix),
	}

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/netbox-tags",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"tags":             tags,
			"netbox_api_token": os.Getenv("NETBOX_API_TOKEN_PRODUCTION"),
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	tagNames := terraform.OutputList(t, terraformOptions, "tag_names")

	assert.ElementsMatch(t, tags, tagNames)
}
