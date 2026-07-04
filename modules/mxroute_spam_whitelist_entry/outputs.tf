output "entry_ids" {
  value       = { for key, wl in mxroute_spam_whitelist_entry.whitelist_entries : key => wl.id }
  description = "Map of each input key to the managed entry's id (`<domain>/<entry>`)."
}
