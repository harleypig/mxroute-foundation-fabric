variable "pointers" {
  description = "Domain pointers (aliases or redirects) to manage, keyed by an arbitrary identifier."

  type = map(object({
    domain  = string
    pointer = string
    alias   = optional(bool)
  }))

  validation {
    condition     = alltrue([for obj in values(var.pointers) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each pointer's domain must be a valid fully-qualified domain name."
  }
}
