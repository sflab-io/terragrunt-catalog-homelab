package terragrunt_stacks_test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// setupPool legt einen isolierten Proxmox-Pool für einen einzelnen Test an und
// gibt die EnvVars zurück, die an alle Stack-Operationen dieses Tests weitergegeben
// werden müssen. Der Pool wird via t.Cleanup automatisch nach dem Test abgebaut.
func setupPool(t *testing.T) map[string]string {
	t.Helper()

	poolID := fmt.Sprintf("tst-%s", random.UniqueId())
	envVars := map[string]string{"TERRATEST_POOL_ID": poolID}

	poolOptions := &terraform.Options{
		TerraformDir:    "../../../examples/terragrunt/stacks/homelab-proxmox-pool",
		TerraformBinary: "terragrunt",
		EnvVars:         envVars,
	}

	t.Cleanup(func() {
		terraform.RunTerraformCommand(t, poolOptions, "stack", "run", "destroy")
	})

	terraform.RunTerraformCommand(t, poolOptions, "stack", "run", "apply")

	return envVars
}
