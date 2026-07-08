output "domain_ids" {
  value       = { for key, domain in mxroute_domain.domains : key => domain.id }
  description = "Map of each input key to the managed domain's id (the domain name)."
}

output "ssl_enabled" {
  value       = { for key, domain in mxroute_domain.domains : key => domain.ssl_enabled }
  description = "Map of each input key to whether a TLS certificate is active for the domain. Read-only status: the MXroute API exposes no operation to request or issue a certificate (they are provisioned out-of-band), so this reports status only."
}

output "pointers" {
  value       = { for key, domain in mxroute_domain.domains : key => domain.pointers }
  description = "Map of each input key to the domain's pointers (aliases)."
}
