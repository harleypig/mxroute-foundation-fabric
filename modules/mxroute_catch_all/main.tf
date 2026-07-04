resource "mxroute_catch_all" "catch_alls" {
  for_each = var.catch_alls

  domain  = each.value.domain
  type    = each.value.type
  address = each.value.address
}
