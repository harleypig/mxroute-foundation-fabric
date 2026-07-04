resource "mxroute_spam_whitelist_entry" "whitelist_entries" {
  for_each = var.whitelist_entries

  domain = each.value.domain
  entry  = each.value.entry
}
