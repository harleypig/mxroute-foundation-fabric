variable "domains" {
  description = "Mail domains to manage, keyed by an arbitrary identifier."

  type = map(object({
    domain       = string
    mail_hosting = optional(bool)
  }))

  validation {
    condition     = alltrue([for obj in values(var.domains) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each domain must be a valid fully-qualified domain name."
  }
}
