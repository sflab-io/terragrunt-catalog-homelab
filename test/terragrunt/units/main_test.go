package terragrunt_units_test

import (
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

func TestAll(t *testing.T) {
	t.Run("UnitNaming", testUnitNaming)
	t.Run("UnitDnsWildcard", testUnitDnsWildcard)
	t.Run("UnitDns", testUnitDns)
	t.Run("UnitProxmoxPool", testUnitProxmoxPool)
	t.Run("UnitProxmoxVm", testUnitProxmoxVm)
	t.Run("UnitProxmoxLxc", testUnitProxmoxLxc)
	t.Run("UnitNetboxTags", testUnitNetboxTags)
	t.Run("UnitNetboxVirtualMachine", testUnitNetboxVirtualMachine)
	t.Run("UnitNetboxK8sCluster", testUnitNetboxK8sCluster)
}
