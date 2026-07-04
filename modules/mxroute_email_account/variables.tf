variable "email_accounts" {
  description = "Email accounts (mailboxes) to manage, keyed by an arbitrary identifier."

  # The whole variable is not marked sensitive because its keys are used as
  # for_each map keys (a sensitive value cannot be a resource instance key).
  # The mailbox password is instead marked sensitive at the point of use in
  # main.tf, and password_wo is a write-only attribute the provider never
  # persists to state.
  type = map(object({
    domain              = string
    username            = string
    password_wo         = string
    password_wo_version = optional(number)
    quota               = optional(number)
    limit               = optional(number)
  }))

  validation {
    condition     = alltrue([for obj in values(var.email_accounts) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each email account's domain must be a valid fully-qualified domain name."
  }

  validation {
    condition     = alltrue([for obj in values(var.email_accounts) : length(obj.username) > 0])
    error_message = "Each email account's username (the local part before the @) must not be empty."
  }
}
