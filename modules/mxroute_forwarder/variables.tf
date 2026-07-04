variable "forwarders" {
  description = "Email forwarders (aliases) to manage, keyed by an arbitrary identifier."

  type = map(object({
    domain       = string
    alias        = string
    destinations = list(string)
  }))

  validation {
    condition     = alltrue([for obj in values(var.forwarders) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each forwarder's domain must be a valid fully-qualified domain name."
  }

  validation {
    condition     = alltrue([for obj in values(var.forwarders) : alltrue([for dest in obj.destinations : can(regex("^[^@\\s]+@[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", dest))])])
    error_message = "Each forwarder destination must be a valid email address."
  }
}
