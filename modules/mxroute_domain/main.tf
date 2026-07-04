resource "mxroute_domain" "domains" {
  for_each = var.domains

  domain       = each.value.domain
  mail_hosting = each.value.mail_hosting
}
