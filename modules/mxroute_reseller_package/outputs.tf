output "package_ids" {
  value       = { for key, pkg in mxroute_reseller_package.packages : key => pkg.id }
  description = "Map of each input key to the managed package's id (the package name)."
}

output "settings" {
  value       = { for key, pkg in mxroute_reseller_package.packages : key => pkg.settings }
  description = "Map of each input key to the package's computed settings (the typed limits MXroute parsed from the configured strings)."
}
