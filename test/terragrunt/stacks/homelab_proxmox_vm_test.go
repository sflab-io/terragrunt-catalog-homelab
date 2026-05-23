package terragrunt_stacks_test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestStackHomelabProxmoxVm(t *testing.T) {
	t.Parallel()

	vmOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/stacks/homelab-proxmox-vm",
		TerraformBinary: "terragrunt",
	}

	defer terraform.RunTerraformCommand(t, vmOptions, "stack", "run", "destroy")

	terraform.RunTerraformCommand(t, vmOptions, "stack", "run", "apply")

	fqdn, err := terraform.RunTerraformCommandAndGetStdoutE(t, vmOptions, "stack", "output", "-raw", "homelab_proxmox_vm.dns.fqdn")
	require.NoError(t, err)

	assert.True(t, strings.HasSuffix(fqdn, ".home.sflab.io"), "FQDN sollte auf .home.sflab.io enden, war: %s", fqdn)
	assert.Contains(t, fqdn, "example-vm-staging", "FQDN sollte 'example-vm-staging' enthalten, war: %s", fqdn)

	ipv4, err := terraform.RunTerraformCommandAndGetStdoutE(t, vmOptions, "stack", "output", "-raw", "homelab_proxmox_vm.proxmox_vm.ipv4")
	require.NoError(t, err)

	assert.NotEmpty(t, ipv4, "IPv4-Adresse sollte nicht leer sein")

	vmName, err := terraform.RunTerraformCommandAndGetStdoutE(t, vmOptions, "stack", "output", "-raw", "homelab_proxmox_vm.proxmox_vm.vm_name")
	require.NoError(t, err)

	assert.Contains(t, vmName, "example-vm-staging", "VM-Name sollte 'example-vm-staging' enthalten, war: %s", vmName)
}
