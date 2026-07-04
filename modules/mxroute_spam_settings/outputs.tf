output "spam_settings_ids" {
  value       = { for key, settings in mxroute_spam_settings.spam_settings : key => settings.id }
  description = "Map of each input key to the managed spam settings' id (the domain name)."
}
