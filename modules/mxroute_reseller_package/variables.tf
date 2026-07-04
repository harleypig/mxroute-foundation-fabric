variable "packages" {
  description = "Reseller packages to manage, keyed by an arbitrary identifier."

  type = map(object({
    name             = string
    quota            = optional(string)
    domains          = optional(string)
    email_accounts   = optional(string)
    email_forwarders = optional(string)
    domain_pointers  = optional(string)
  }))

  validation {
    condition     = alltrue([for obj in values(var.packages) : length(trimspace(obj.name)) > 0])
    error_message = "Each package must have a non-empty name."
  }
}
