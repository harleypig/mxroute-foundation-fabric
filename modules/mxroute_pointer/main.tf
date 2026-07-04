resource "mxroute_pointer" "pointers" {
  for_each = var.pointers

  domain  = each.value.domain
  pointer = each.value.pointer
  alias   = each.value.alias
}
