variable "users" {
  description = "Reseller-managed users to manage, keyed by an arbitrary identifier."

  type = map(object({
    username            = string
    email               = string
    package             = string
    password_wo         = string
    password_wo_version = optional(number)
    quota               = optional(string)
    suspended           = optional(bool)
  }))

  # The whole variable is not marked sensitive: a sensitive value cannot be
  # used as a for_each key. password_wo is protected instead by the provider's
  # write-only attribute, so it is never persisted to state.

  validation {
    condition     = alltrue([for obj in values(var.users) : length(obj.username) > 0])
    error_message = "Each user's username must be non-empty."
  }

  validation {
    condition     = alltrue([for obj in values(var.users) : can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", obj.email))])
    error_message = "Each user's email must be a valid email address."
  }
}
