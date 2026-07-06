variable "users" {
  description = "Reseller-managed users to manage, keyed by an arbitrary identifier."

  type = map(object({
    username            = string
    email               = string
    package             = string
    password_wo         = optional(string)
    password_wo_version = optional(number)
    quota               = optional(string)
    suspended           = optional(bool)
  }))

  # The whole variable is not marked sensitive: a sensitive value cannot be
  # used as a for_each key. password_wo is protected instead by the provider's
  # write-only attribute, so it is never persisted to state. It is optional
  # (provider >= 0.3.0): the provider requires it only when creating a user, so
  # an existing user can omit it (the password is left unchanged).

  validation {
    condition     = alltrue([for obj in values(var.users) : length(obj.username) > 0])
    error_message = "Each user's username must be non-empty."
  }

  # Mirrors the provider's own validator (>= 0.3.0): password_wo has a minimum
  # length of 8.
  validation {
    condition     = alltrue([for obj in values(var.users) : obj.password_wo == null || length(obj.password_wo) >= 8])
    error_message = "Each user's password_wo, when set, must be at least 8 characters."
  }

  validation {
    condition     = alltrue([for obj in values(var.users) : can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", obj.email))])
    error_message = "Each user's email must be a valid email address."
  }
}
