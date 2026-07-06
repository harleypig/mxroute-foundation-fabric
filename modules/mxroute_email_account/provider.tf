terraform {
  required_version = ">= 1.11"

  required_providers {
    mxroute = {
      source  = "harleypig/mxroute"
      version = ">= 0.3.0"
    }
  }
}
