output "descriptions" {
  value       = { for key, catch_all in mxroute_catch_all.catch_alls : key => catch_all.description }
  description = "Map of each input key to the catch-all policy's server-reported description."
}

output "catch_all_ids" {
  value       = { for key, catch_all in mxroute_catch_all.catch_alls : key => catch_all.id }
  description = "Map of each input key to the managed catch-all policy's id (the domain name)."
}
