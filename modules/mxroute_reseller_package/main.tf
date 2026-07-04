resource "mxroute_reseller_package" "packages" {
  for_each = var.packages

  name             = each.value.name
  quota            = each.value.quota
  domains          = each.value.domains
  email_accounts   = each.value.email_accounts
  email_forwarders = each.value.email_forwarders
  domain_pointers  = each.value.domain_pointers
}
