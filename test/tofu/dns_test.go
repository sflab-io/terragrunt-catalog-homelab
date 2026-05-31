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

func testModuleDns(t *testing.T) {
	appName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
	zone := "home.sflab.io"
	env := "dev"
	address := "192.168.1.200"

	terraformOptions := &terraform.Options{
		TerraformDir:    "../../examples/tofu/dns",
		TerraformBinary: "tofu",
		Vars: map[string]any{
			"app":     appName,
			"env":     env,
			"zone":    zone,
			"address": address,
		},
		EnvVars: map[string]string{
			"TF_VAR_technitium_tsig_key_secret": os.Getenv("TECHNITIUM_TSIG_KEY_SECRET"),
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	fqdn := terraform.Output(t, terraformOptions, "fqdn")
	fqdnWildcard := terraform.Output(t, terraformOptions, "fqdn_wildcard")

	assert.Equal(t, fmt.Sprintf("%s-%s.%s", appName, env, zone), fqdn)
	assert.Equal(t, fmt.Sprintf("*.%s-%s.%s", appName, env, zone), fqdnWildcard)
}
