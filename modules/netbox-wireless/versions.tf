terraform {
  required_providers {
    # Pinned to ~> 2.0 (SDKv2) to avoid a plan-time validation bug in v3.0.
    # restapi v3.0 migrated to the Terraform Plugin Framework and uses
    # jsontypes.Normalized for the `data` attribute. When jsonencode() is called
    # on merge() results with heterogeneous object types (e.g. some wireless LANs
    # have auth_type/auth_cipher and others don't), OpenTofu's type unification
    # produces a value that serializes to an empty string, which fails the
    # json.Valid() check and causes an "Invalid JSON String Value" plan error.
    restapi = {
      source  = "Mastercard/restapi"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.9.0"
}
