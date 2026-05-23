package terragrunt_stacks_test

import (
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

func TestAll(t *testing.T) {
	t.Run("StackHomelabProxmoxLxc", testStackHomelabProxmoxLxc)
	t.Run("StackHomelabProxmoxVm", testStackHomelabProxmoxVm)
	t.Run("StackHomelabNetboxVirtualMachine", testStackHomelabNetboxVirtualMachine)
}
