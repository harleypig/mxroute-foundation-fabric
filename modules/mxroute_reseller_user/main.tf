resource "mxroute_reseller_user" "users" {
  for_each = var.users

  username            = each.value.username
  email               = each.value.email
  package             = each.value.package
  password_wo         = sensitive(each.value.password_wo)
  password_wo_version = each.value.password_wo_version
  quota               = each.value.quota
  suspended           = each.value.suspended
}
