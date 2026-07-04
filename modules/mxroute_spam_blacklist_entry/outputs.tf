output "entry_ids" {
  value       = { for key, entry in mxroute_spam_blacklist_entry.blacklist_entries : key => entry.id }
  description = "Map of each input key to the managed blacklist entry's id (`<domain>/<entry>`)."
}
