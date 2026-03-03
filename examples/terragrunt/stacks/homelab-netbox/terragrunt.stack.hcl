locals {
  version = "feat/netbox"

  region_name = "sflab Homelab Region"
  region_description = "Region for sflab homelab infrastructure"

  site_name = "sflab Homelab Site"
  site_facility = "sflab Homelab Facility"
  site_latitude = "48.7844"
  site_longitude = "9.2078"
  timezone = "Europe/Berlin"
}

unit "netbox" {
  source = "../../../../units/netbox"

  path = "netbox"

  values = {
    version = local.version

    # Required values
    region_name = local.region_name
    region_description = local.region_description

    site_name = local.site_name
    site_facility = local.site_facility
    site_latitude = local.site_latitude
    site_longitude = local.site_longitude
    timezone = local.timezone

    # Optional values
    # ...
  }
}
