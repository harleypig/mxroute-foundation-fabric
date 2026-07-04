resource "mxroute_email_account" "email_accounts" {
  for_each = var.email_accounts

  domain              = each.value.domain
  username            = each.value.username
  password_wo         = sensitive(each.value.password_wo)
  password_wo_version = each.value.password_wo_version
  quota               = each.value.quota
  limit               = each.value.limit
}
