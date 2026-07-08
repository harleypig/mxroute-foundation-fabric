terraform {
  required_version = ">= 1.11"

  required_providers {
    mxroute = {
      source = "harleypig/mxroute"
      # >= 0.4.0: reading a domain with pointers only decodes correctly from
      # this version on (the live API returns pointers as a keyed object, not
      # the documented array of strings), so the pointers output needs it.
      version = ">= 0.4.0"
    }
  }
}
