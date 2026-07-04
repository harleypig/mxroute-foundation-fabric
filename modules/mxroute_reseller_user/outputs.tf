output "ids" {
  value       = { for key, user in mxroute_reseller_user.users : key => user.id }
  description = "Map of each input key to the managed user's id (the username)."
}

output "domains" {
  value       = { for key, user in mxroute_reseller_user.users : key => user.domain }
  description = "Map of each input key to the user's primary domain."
}

output "quota_used" {
  value       = { for key, user in mxroute_reseller_user.users : key => user.quota_used }
  description = "Map of each input key to the user's current storage usage in megabytes."
}

output "quota_unlimited" {
  value       = { for key, user in mxroute_reseller_user.users : key => user.quota_unlimited }
  description = "Map of each input key to whether the user's quota is unlimited."
}

output "quota_limit" {
  value       = { for key, user in mxroute_reseller_user.users : key => user.quota_limit }
  description = "Map of each input key to the user's storage quota limit in megabytes (null when unlimited)."
}
