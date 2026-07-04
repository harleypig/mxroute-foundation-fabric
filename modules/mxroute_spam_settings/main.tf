resource "mxroute_spam_settings" "spam_settings" {
  for_each = var.spam_settings

  domain     = each.value.domain
  high_score = each.value.high_score
}
