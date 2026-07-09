variable "forwarders" {
  description = <<-EOT
    Email forwarders (aliases) to manage, keyed by an arbitrary identifier.
    Each destination is an email address, or one of the special Exim targets
    ":fail:" (reject the alias at SMTP) or ":blackhole:" (silently discard it).
    Destinations are an unordered set: reordering them does not force a
    spurious destroy/recreate of a live forwarder.
  EOT

  type = map(object({
    domain       = string
    alias        = string
    destinations = set(string)
  }))

  validation {
    condition     = alltrue([for obj in values(var.forwarders) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each forwarder's domain must be a valid fully-qualified domain name."
  }

  # Mirrors the provider's alias validator (>= 1.0.0): the local part must
  # start with a letter or number, then contain only letters, numbers, dots,
  # underscores, and hyphens. An invalid alias fails at plan instead of an
  # HTTP 400 VALIDATION_ERROR at apply.
  validation {
    condition     = alltrue([for obj in values(var.forwarders) : can(regex("^[A-Za-z0-9][A-Za-z0-9._-]*$", obj.alias))])
    error_message = "Each forwarder's alias must start with a letter or number and contain only letters, numbers, dots, underscores, and hyphens."
  }

  validation {
    condition     = alltrue([for obj in values(var.forwarders) : alltrue([for dest in obj.destinations : contains([":fail:", ":blackhole:"], dest) || can(regex("^[^@\\s]+@[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", dest))])])
    error_message = "Each forwarder destination must be a valid email address or the special target \":fail:\" or \":blackhole:\"."
  }
}
