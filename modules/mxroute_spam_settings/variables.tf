variable "spam_settings" {
  description = "Per-domain spam settings to manage, keyed by an arbitrary identifier."

  type = map(object({
    domain     = string
    high_score = number
  }))

  validation {
    condition     = alltrue([for obj in values(var.spam_settings) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each domain must be a valid fully-qualified domain name."
  }

  validation {
    condition     = alltrue([for obj in values(var.spam_settings) : obj.high_score >= 1 && obj.high_score <= 50])
    error_message = "Each high_score must be between 1 and 50 inclusive."
  }
}
