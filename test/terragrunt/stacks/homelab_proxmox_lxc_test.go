package terragrunt_stacks_test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestStackHomelabProxmoxLxc(t *testing.T) {
	t.Parallel()

	lxcOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/stacks/homelab-proxmox-lxc",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, lxcOptions, "stack", "run", "destroy")

	terraform.RunTerraformCommand(t, lxcOptions, "stack", "run", "apply")

	fqdn, err := terraform.RunTerraformCommandAndGetStdoutE(t, lxcOptions, "stack", "output", "-raw", "homelab_proxmox_lxc.dns.fqdn")
	require.NoError(t, err)

	assert.True(t, strings.HasSuffix(fqdn, ".home.sflab.io"), "FQDN sollte auf .home.sflab.io enden, war: %s", fqdn)
	assert.Contains(t, fqdn, "example-lxc-staging", "FQDN sollte 'example-lxc-staging' enthalten, war: %s", fqdn)

	ipv4, err := terraform.RunTerraformCommandAndGetStdoutE(t, lxcOptions, "stack", "output", "-raw", "homelab_proxmox_lxc.proxmox_lxc.ipv4")
	require.NoError(t, err)

	assert.NotEmpty(t, ipv4, "IPv4-Adresse sollte nicht leer sein")
}
