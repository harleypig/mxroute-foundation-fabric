resource "mxroute_spam_blacklist_entry" "blacklist_entries" {
  for_each = var.blacklist_entries

  domain = each.value.domain
  entry  = each.value.entry
}
