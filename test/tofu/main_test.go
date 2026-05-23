package tofu_test

import (
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

func TestAll(t *testing.T) {
	t.Run("ModuleNaming", testModuleNaming)
	t.Run("ModuleDns", testModuleDns)
	t.Run("ModuleProxmoxPool", testModuleProxmoxPool)
	t.Run("ModuleProxmoxLxc", testModuleProxmoxLxc)
	t.Run("ModuleProxmoxVm", testModuleProxmoxVm)
	t.Run("ModuleNetboxVirtualMachine", testModuleNetboxVirtualMachine)
	t.Run("ModuleNetboxTags", testModuleNetboxTags)
}
