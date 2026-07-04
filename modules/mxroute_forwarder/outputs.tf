output "forwarder_ids" {
  value       = { for key, forwarder in mxroute_forwarder.forwarders : key => forwarder.id }
  description = "Map of each input key to the managed forwarder's id (`<domain>/<alias>`)."
}

output "emails" {
  value       = { for key, forwarder in mxroute_forwarder.forwarders : key => forwarder.email }
  description = "Map of each input key to the full forwarding address (`<alias>@<domain>`)."
}
