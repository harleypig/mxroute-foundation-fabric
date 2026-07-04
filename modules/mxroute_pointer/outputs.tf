output "pointer_ids" {
  value       = { for key, pointer in mxroute_pointer.pointers : key => pointer.id }
  description = "Map of each input key to the managed pointer's id (`<domain>/<pointer>`)."
}

output "types" {
  value       = { for key, pointer in mxroute_pointer.pointers : key => pointer.type }
  description = "Map of each input key to the pointer type reported by the API (`alias` or `redirect`)."
}

output "targets" {
  value       = { for key, pointer in mxroute_pointer.pointers : key => pointer.target }
  description = "Map of each input key to the target the pointer resolves to."
}
