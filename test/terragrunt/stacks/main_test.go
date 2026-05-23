package terragrunt_stacks_test

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

func TestMain(m *testing.M) {
	poolDir, err := filepath.Abs("../../../examples/terragrunt/stacks/homelab-proxmox-pool")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to resolve pool dir: %v\n", err)
		os.Exit(1)
	}

	applyCmd := exec.Command("terragrunt", "--non-interactive", "stack", "run", "apply")
	applyCmd.Dir = poolDir
	applyCmd.Stdout = os.Stdout
	applyCmd.Stderr = os.Stderr
	if err := applyCmd.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to apply pool: %v\n", err)
		os.Exit(1)
	}

	exitCode := m.Run()

	destroyCmd := exec.Command("terragrunt", "--non-interactive", "stack", "run", "destroy")
	destroyCmd.Dir = poolDir
	destroyCmd.Stdout = os.Stdout
	destroyCmd.Stderr = os.Stderr
	if err := destroyCmd.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Failed to destroy pool: %v\n", err)
	}

	os.Exit(exitCode)
}
