package tofu_test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleNetboxTags(t *testing.T) {
	t.Parallel()

	suffix := strings.ToLower(random.UniqueId())
	tags := []string{
		fmt.Sprintf("test-tag-a-%s", suffix),
		fmt.Sprintf("test-tag-b-%s", suffix),
	}

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/netbox-tags",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"tags": tags,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	tagNames := terraform.OutputList(t, terraformOptions, "tag_names")

	assert.ElementsMatch(t, tags, tagNames)
}
