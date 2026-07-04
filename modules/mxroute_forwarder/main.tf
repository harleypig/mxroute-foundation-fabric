resource "mxroute_forwarder" "forwarders" {
  for_each = var.forwarders

  domain       = each.value.domain
  alias        = each.value.alias
  destinations = each.value.destinations
}
