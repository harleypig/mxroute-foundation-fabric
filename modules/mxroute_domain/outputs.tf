output "domain_ids" {
  value       = { for key, domain in mxroute_domain.domains : key => domain.id }
  description = "Map of each input key to the managed domain's id (the domain name)."
}

output "ssl_enabled" {
  value       = { for key, domain in mxroute_domain.domains : key => domain.ssl_enabled }
  description = "Map of each input key to whether SSL is enabled (server-managed via MXroute AutoSSL)."
}

output "pointers" {
  value       = { for key, domain in mxroute_domain.domains : key => domain.pointers }
  description = "Map of each input key to the domain's pointers (aliases)."
}
