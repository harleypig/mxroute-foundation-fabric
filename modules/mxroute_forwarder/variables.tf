variable "forwarders" {
  description = <<-EOT
    Email forwarders (aliases) to manage, keyed by an arbitrary identifier.
    Each destination is an email address, or one of the special Exim targets
    ":fail:" (reject the alias at SMTP) or ":blackhole:" (silently discard it).
    Destinations are an unordered set (provider >= 0.3.0): reordering them does
    not force a spurious destroy/recreate of a live forwarder.
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

  validation {
    condition     = alltrue([for obj in values(var.forwarders) : alltrue([for dest in obj.destinations : contains([":fail:", ":blackhole:"], dest) || can(regex("^[^@\\s]+@[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", dest))])])
    error_message = "Each forwarder destination must be a valid email address or the special target \":fail:\" or \":blackhole:\"."
  }
}
