variable "email_accounts" {
  description = "Email accounts (mailboxes) to manage, keyed by an arbitrary identifier."

  # The whole variable is not marked sensitive because its keys are used as
  # for_each map keys (a sensitive value cannot be a resource instance key).
  # The mailbox password is instead marked sensitive at the point of use in
  # main.tf, and password_wo is a write-only attribute the provider never
  # persists to state. It is optional: the provider requires it only when
  # creating a mailbox, so an existing mailbox can omit it (the password is
  # left unchanged). The API enforces password complexity at create (a mix of
  # uppercase, lowercase, numbers, and special characters); a too-simple
  # password fails apply with a VALIDATION_ERROR. `limit` is not an input: the
  # provider exposes it read-only (>= 1.0.0), so it surfaces as an output only.
  type = map(object({
    domain              = string
    username            = string
    password_wo         = optional(string)
    password_wo_version = optional(number)
    quota               = optional(number)
  }))

  validation {
    condition     = alltrue([for obj in values(var.email_accounts) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each email account's domain must be a valid fully-qualified domain name."
  }

  validation {
    condition     = alltrue([for obj in values(var.email_accounts) : length(obj.username) > 0])
    error_message = "Each email account's username (the local part before the @) must not be empty."
  }

  # Mirrors the provider's own validator: password_wo has a minimum length of 8.
  validation {
    condition     = alltrue([for obj in values(var.email_accounts) : obj.password_wo == null || length(obj.password_wo) >= 8])
    error_message = "Each email account's password_wo, when set, must be at least 8 characters."
  }
}
